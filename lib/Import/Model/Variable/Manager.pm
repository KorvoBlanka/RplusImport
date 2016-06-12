package Import::Model::Variable::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::Variable;

sub object_class { 'Import::Model::Variable' }

__PACKAGE__->make_manager_methods('variables');

1;

