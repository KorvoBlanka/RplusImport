package Import::DB::Object;

use Import::Modern;

use base qw(Rose::DB::Object);

use Import::DB;
use Import::DB::Object::Metadata;

use Rose::DB::Object::Helpers qw(as_tree column_value_pairs);

#
# Class methods
#

sub init_db { Import::DB->new_or_cached }

sub meta_class { 'Import::DB::Object::Metadata' }

#
# Additional operators
#
$Rose::DB::Object::QueryBuilder::Op_Map{'@@'} = '@@';
$Rose::DB::Object::QueryBuilder::Op_Map{'&&'} = '&&';

1;
