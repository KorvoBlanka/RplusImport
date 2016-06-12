package Import::Model::AddressObject::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::AddressObject;

sub object_class { 'Import::Model::AddressObject' }

__PACKAGE__->make_manager_methods('address_objects');

1;

