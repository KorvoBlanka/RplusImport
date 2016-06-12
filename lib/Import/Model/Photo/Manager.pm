package Import::Model::Photo::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::Photo;

sub object_class { 'Import::Model::Photo' }

__PACKAGE__->make_manager_methods('photos');

1;

