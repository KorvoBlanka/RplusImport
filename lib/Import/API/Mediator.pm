package Import::API::Mediator;

use Mojo::Base 'Mojolicious::Controller';

use Import::Model::Mediator;
use Import::Model::Mediator::Manager;
use Import::Model::MediatorCompany;
use Import::Model::MediatorCompany::Manager;

use JSON;
use Mojo::Collection;

no warnings 'experimental::smartmatch';

my $_serialize = sub {
    my $self = shift;

    return '';
};

sub list_companies {
    my $self = shift;

    my $last_id = 0;
    if (my $id = $self->param_n('last_id')) {
        $last_id = $id;
    }

    my $res = {
        count => 0,
        list => [],
    };

    my $company_iter = Import::Model::MediatorCompany::Manager->get_objects_iterator(query => [delete_date => undef]);
    while (my $company = $company_iter->next) {
        my $x = {
            id => $company->id,
            name => $company->name,
        };
        push @{$res->{list}}, $x;
    }

    $res->{count} = scalar @{$res->{list}};

    return $self->render(json => $res);
}

sub list_mediators {
    my $self = shift;

    my $company_id = $self->param('company_id');

    return $self->render(json => {error => 'Bad Request'}, status => 400) unless $company_id;

    my $res = {
        count => 0,
        list => [],
    };

    my $mediator_iter = Import::Model::Mediator::Manager->get_objects_iterator(
        query => [
            company_id => $company_id,
            delete_date => undef,
        ],
    );
    while (my $mediator = $mediator_iter->next) {
        my $x = {
            id => $mediator->id,
            name => $mediator->name,
            phone_num => $mediator->phone_num,
        };
        push @{$res->{list}}, $x;
    }

    $res->{count} = scalar @{$res->{list}};

    return $self->render(json => $res);
}

sub list_mediators_ex {
    my $self = shift;
    my $mode = $self->param('mode') || 'new';    # new, deleted
    my $ts = $self->param('ts') || '2014-01-01T00:00:00+11';

    my $res = {
        list => [],
    };

    my @query;
    if ($mode eq 'new') {
        push @query, delete_date => undef;
        push @query, add_date => {gt => $ts};
    } else {
        push @query, delete_date => {gt => $ts};
    }

    my $mediator_iter = Import::Model::Mediator::Manager->get_objects_iterator(
        query => [
            @query,
        ],
    );
    while (my $mediator = $mediator_iter->next) {
        my $x = {
            id => $mediator->id,
            name => $mediator->name,
            phone_num => $mediator->phone_num,
            company_name => $mediator->company->name,
        };
        push @{$res->{list}}, $x;
    }

    return $self->render(json => $res);
}

1;
