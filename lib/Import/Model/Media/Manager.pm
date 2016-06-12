package Import::Model::Media::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::Media;

sub object_class { 'Import::Model::Media' }

__PACKAGE__->make_manager_methods('media');

1;

