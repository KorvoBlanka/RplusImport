package Import::Model::MediatorCompany::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::MediatorCompany;

sub object_class { 'Import::Model::MediatorCompany' }

__PACKAGE__->make_manager_methods('mediator_companies');

1;

