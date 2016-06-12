package Import::Model::RealtyType::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::RealtyType;

sub object_class { 'Import::Model::RealtyType' }

__PACKAGE__->make_manager_methods('realty_types');

1;

