package Import::Model::Realty::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::Realty;

sub object_class { 'Import::Model::Realty' }

__PACKAGE__->make_manager_methods('realty');

1;

