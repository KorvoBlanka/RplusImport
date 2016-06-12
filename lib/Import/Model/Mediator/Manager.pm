package Import::Model::Mediator::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::Mediator;

sub object_class { 'Import::Model::Mediator' }

__PACKAGE__->make_manager_methods('mediators');

1;

