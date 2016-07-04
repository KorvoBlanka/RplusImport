package Import::Util::Mediator;

use Import::Modern;

use Import::Model::Mediator;
use Import::Model::Mediator::Manager;
use Import::Model::MediatorCompany;
use Import::Model::MediatorCompany::Manager;

use Exporter qw(import);

our @EXPORT_OK = qw(delete_mediator add_mediator remove_obsolete_mediators);


sub remove_obsolete_mediators {
    my $obs_period = shift;
    my $num_rows_updated = Import::Model::Mediator::Manager->update_objects(
        set => {delete_date => \'now()'},
        where => [
            [\"last_seen_date < (NOW() - INTERVAL '$obs_period day')"],
            delete_date => undef],
    );

    return $num_rows_updated;
}


sub delete_mediator {
    my $id = shift;

    my $num_rows_updated = Import::Model::Mediator::Manager->update_objects(
        set => {delete_date => \'now()'},
        where => [id => $id, delete_date => undef],
    );

    return $num_rows_updated;
}


sub add_mediator {

    # Prepare data
    my $company_name = shift;
    my $phone_num = shift;

	my $mediator;
	if (Import::Model::Mediator::Manager->get_objects_count(query => [phone_num => $phone_num, delete_date => undef])) {
		$mediator = Import::Model::Mediator::Manager->get_objects(query => [phone_num => $phone_num, delete_date => undef])->[0];
	} else {
		$mediator = Import::Model::Mediator->new(phone_num => $phone_num);
	}

    my $company = Import::Model::MediatorCompany::Manager->get_objects(query => [[\'lower(name) = ?' => lc($company_name)], delete_date => undef])->[0];
    unless ($company) {
        $company = Import::Model::MediatorCompany->new(name => $company_name);
        $company->save(changes_only => 1);;
    }
    $mediator->company_id($company->id);
    $mediator->last_seen_date('now()');
    $mediator->save(changes_only => 1);
}

1;
