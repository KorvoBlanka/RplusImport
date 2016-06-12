package Import::Model::MediaImportHistory::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::MediaImportHistory;

sub object_class { 'Import::Model::MediaImportHistory' }

__PACKAGE__->make_manager_methods('media_import_history');

1;

