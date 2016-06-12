package Import::Model::ImportTask::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::ImportTask;

sub object_class { 'Import::Model::ImportTask' }

__PACKAGE__->make_manager_methods('import_tasks');

1;

