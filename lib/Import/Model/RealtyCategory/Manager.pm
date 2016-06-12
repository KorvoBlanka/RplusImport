package Import::Model::RealtyCategory::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::RealtyCategory;

sub object_class { 'Import::Model::RealtyCategory' }

__PACKAGE__->make_manager_methods('realty_categories');

1;

