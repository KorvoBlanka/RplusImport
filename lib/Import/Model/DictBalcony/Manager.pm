package Import::Model::DictBalcony::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::DictBalcony;

sub object_class { 'Import::Model::DictBalcony' }

__PACKAGE__->make_manager_methods('dict_balconies');

1;

