package Import::Model::DictCondition::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::DictCondition;

sub object_class { 'Import::Model::DictCondition' }

__PACKAGE__->make_manager_methods('dict_conditions');

1;

