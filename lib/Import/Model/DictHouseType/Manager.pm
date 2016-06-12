package Import::Model::DictHouseType::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::DictHouseType;

sub object_class { 'Import::Model::DictHouseType' }

__PACKAGE__->make_manager_methods('dict_house_types');

1;

