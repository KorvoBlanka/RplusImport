package Import::Model::DictApScheme::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::DictApScheme;

sub object_class { 'Import::Model::DictApScheme' }

__PACKAGE__->make_manager_methods('dict_ap_schemes');

1;

