package RplusImport;

use Mojo::Base 'Mojolicious';

our $VERSION = '1.0';

use Import::DB;

use JSON;
use Hash::Merge;
use Scalar::Util qw(blessed);
use Mojo::Util qw(trim);
use DateTime::Format::Pg qw();
use DateTime::Format::Strptime qw();
use Time::HiRes qw( time usleep );
use Cache::FastMmap;


# This method will run once at server start
sub startup {
    my $self = shift;

    my $cache = Cache::FastMmap->new();
    $cache->set('events',  []);
    $cache->set('elock',  0);
    $cache->set('cc', 0);
    my $eid = 0;

    # Plugins
    my $config = $self->plugin('Config' => {file => 'app.conf'});

    # Secret
    $self->secrets($config->{secrets} || ($config->{secret} && [$config->{secret}]) || ['no secret defined']);

    # Default stash values
    $self->defaults(
        bla => '1',
    );

    # DB helper
    $self->helper(db => sub { Rplus::DB->new_or_cached });
        
    # DateTime formatter helper
    $self->helper(format_datetime => sub {
        my ($self, $dt) = @_;
        return undef unless $dt;
        $dt = DateTime::Format::Pg->parse_timestamptz($dt) unless blessed $dt;
        return $dt->strftime('%FT%T%z');
    });

    # DateTime parser helper
    $self->helper(parse_datetime => sub {
        my ($self, $str) = @_;
        return undef unless $str;
        return DateTime::Format::Strptime::strptime("%FT%T%z", $str);
    });

    $self->helper(parse_datetime_local => sub {
        my ($self, $str) = @_;
        return undef unless $str;
        my $dt = DateTime::Format::Strptime::strptime("%FT%T", $str);
        $dt->set_time_zone('local');
        return $dt;
    });

    # PhoneNum formatter helper
    $self->helper(format_phone_num => sub {
        my ($self, $phone_num, $phone_prefix) = @_;
        return undef unless $phone_num;
        $phone_prefix //= $self->config->{default_phone_prefix};
        return $phone_num =~ s/^(\Q$phone_prefix\E)(\d+)$/($1)$2/r if $phone_prefix && $phone_num =~ /^\Q$phone_prefix\E/;
        return $phone_num =~ s/^(\d{3})(\d{3})(\d{4})/($1)$2$3/r;
    });

    # PhoneNum parser helper
    $self->helper(parse_phone_num => sub {
        my ($self, $phone_num, $phone_prefix) = @_;
        return undef unless $phone_num;
        $phone_prefix //= $self->config->{default_phone_prefix};
        if ($phone_num !~ /^\d{10}$/) {
            $phone_num =~ s/\D//g;
            $phone_num =~ s/^(7|8)(\d{10})$/$2/;
            $phone_num = $phone_prefix.$phone_num if "$phone_prefix$phone_num" =~ /^\d{10}$/;
            return undef unless $phone_num =~ /^\d{10}$/;
        }
        return $phone_num;
    });

    # "Normalized" param helper
    $self->helper(param_n => sub {
        my ($self, $name) = @_;
        my $x = $self->param($name); $x = trim($x) || undef if defined $x;
        return $x;
    });

    # "Boolean" param helper
    $self->helper(param_b => sub {
        my ($self, $name) = @_;
        my $x = $self->param($name);
        return undef unless defined $x;
        return $x && lc($x) ne 'false' ? 1 : 0;
    });

    # Router
    my $r = $self->routes;

    # Main controller
    $r->get('/')->to(template => 'main/index');

    # API namespace
    $r->route('/api/:controller')->bridge->to(cb => sub {
        my $self = shift;
        return 1;
    })->route('/:action')->to(namespace => 'Import::API');
}

1;
