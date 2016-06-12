package Import::Model::DictRoomScheme::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::DictRoomScheme;

sub object_class { 'Import::Model::DictRoomScheme' }

__PACKAGE__->make_manager_methods('dict_room_schemes');

1;

