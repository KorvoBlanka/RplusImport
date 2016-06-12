package Import::API::Realty;

use Mojo::Base 'Mojolicious::Controller';

use Import::Model::Media;
use Import::Model::Media::Manager;
use Import::Model::Realty;
use Import::Model::Realty::Manager;
use Import::Model::Photo;
use Import::Model::Photo::Manager;

use JSON;
use Mojo::Collection;

no warnings 'experimental::smartmatch';

# Private function: serialize realty object(s)
my $_serialize = sub {
    my $self = shift;
    my @realty_objs = (ref($_[0]) eq 'ARRAY' ? @{shift()} : shift);
    my %params = @_;

    my @serialized;
    for my $realty (@realty_objs) {
        my $x = {
            (map { $_ => ($_ =~ /_date$/ ? $self->format_datetime($realty->$_) : scalar($realty->$_)) } grep { !($_ ~~ [qw(delete_date geocoords landmarks metadata fts)]) } $realty->meta->column_names),
        };

        push @serialized, $x;
    }

    return @realty_objs == 1 ? $serialized[0] : @serialized;
};

sub list {
    my $self = shift;

    # Input params
    #last_id => $last_id, offer_type => $offer_type, source => $source, category => $category

    my $last_ts = $self->param('last_ts');
    my $offer_type = $self->param('offer_type') || 'any'; # sale | rent
    my $realty_type = $self->param('realty_type') || 'any'; # flat, room e.t.c

    my $page = $self->param('page') || 1;
    my $per_page = $self->param('per_page') || 30;

    my @query;
    {
      if ($last_ts) {
        push @query, state_change_date => {gt => $last_ts};
      }

      if ($offer_type ne 'any') {
        push @query, offer_type_code => $offer_type;
      }

      if ($realty_type ne 'any') {
        push @query, type_code => $realty_type;
      }
    }


    my $realty_objs = Import::Model::Realty::Manager->get_objects(
        select => ['realty.*', ],
        query => [
          @query,
          delete_date => undef
        ],
        sort_by => ['realty.id desc', ],
        page => $page,
        per_page => $per_page
    );

    my $res = {
        count => scalar @$realty_objs,
        list => [$_serialize->($self, $realty_objs)],
    };

    return $self->render(json => $res);
}

sub get_photos {
    my $self = shift;

    my $realty_id = $self->param('realty_id');
    my $realty = Import::Model::Realty::Manager->get_objects(select => 'id, agent_id', query => [id => $realty_id, delete_date => undef])->[0];
    return $self->render(json => {error => 'Not Found'}, status => 404) unless $realty;

    my $res = {
        count => 0,
        list => [],
    };

    my $photo_iter = Import::Model::Photo::Manager->get_objects_iterator(query => [realty_id => $realty_id, delete_date => undef], sort_by => 'id');
    while (my $photo = $photo_iter->next) {
        my $x = {
            id => $photo->id,
            photo_url => $self->config->{'storage'}->{'url'}.'/photos/'.$photo->realty_id.'/'.$photo->filename,
            thumbnail_url => $self->config->{'storage'}->{'url'}.'/photos/'.$photo->realty_id.'/'.$photo->thumbnail_filename,
        };
        push @{$res->{list}}, $x;
    }

    $res->{count} = scalar @{$res->{list}};

    return $self->render(json => $res);
}

1;
