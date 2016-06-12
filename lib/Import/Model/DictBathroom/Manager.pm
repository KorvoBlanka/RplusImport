package Import::Model::DictBathroom::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::DictBathroom;

sub object_class { 'Import::Model::DictBathroom' }

__PACKAGE__->make_manager_methods('dict_bathrooms');

1;

