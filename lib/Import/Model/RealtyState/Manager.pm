package Import::Model::RealtyState::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::RealtyState;

sub object_class { 'Import::Model::RealtyState' }

__PACKAGE__->make_manager_methods('realty_states');

1;

