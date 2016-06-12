package Import::API::RemoteImport;

use Mojo::Base 'Mojolicious::Controller';

use Import::Modern;

use Import::Model::Media;
use Import::Model::Media::Manager;
use Import::Model::Realty;
use Import::Model::Realty::Manager;
use Import::Model::Photo;
use Import::Model::Photo::Manager;
use Import::Model::ImportTask;
use Import::Model::ImportTask::Manager;

use Import::Util::Mediator qw(add_mediator);

use JSON;
use Mojo::Collection;
use Mojo::UserAgent;
use Mojo::ByteStream;

use Import::Util::Image;
use Data::Dumper;

no warnings 'experimental::smartmatch';

my $ua = Mojo::UserAgent->new;
$ua->max_redirects(4);

sub get_task {
    my $self = shift;

    my $source = $self->param('source');
    my $count = $self->param('count');

    my $list = [];

    my $task_iter = Import::Model::ImportTask::Manager->get_objects_iterator(
        query => [
            source_name => $source,
            delete_date => undef
        ],
        sort_by => 'id DESC',
        limit => $count,
    );
    while (my $task = $task_iter->next) {
        my $x = {
            url => $task->source_url,
        };
        push @{$list}, $x;
        $task->delete_date('now()');
        $task->save;
    }

    return $self->render(json => {state => 'ok', list => $list});
}

sub upload_result {
    my $self = shift;

    my $data_str = $self->param('data');
    my $data = eval $data_str;

    my $photos = $data->{photos};
    my $addr = $data->{addr};

    my $mediator_company = $data->{mediator_company};

    my $m_flag = 0;
    if ($mediator_company) {
        say 'mediator: ' . $mediator_company;
        $m_flag = 1;
        foreach (@{$data->{'owner_phones'}}) {
            say 'add mediator ' . $_;
            add_mediator($mediator_company, $_);
        }
    }

    if ($addr) {
        $data->{'address'} = $addr;
    }

    say Dumper $data;

    my $realty = Import::Model::Realty->new((map { $_ => $data->{$_} } grep { $_ ne 'addr' && $_ ne 'photos' && $_ ne 'mediator_company' } keys %$data), state_code => 'raw');
    $realty->save;
    my $id = $realty->id;
    say "Saved new realty: $id";

    foreach (@{$photos}) {
        my $image = $ua->get($_)->res->content->asset;
        say 'Loading img ' . $_;
        Import::Util::Image::load_image($id, $image, , $self->config->{storage}->{path}, $self->config->{import}->{avito}->{crop_image_y});
    }

    return $self->render(json => {state => 'ok', id => $id, m_flag => $m_flag,});
}

1;
