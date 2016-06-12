package Import::DB::Object::Metadata;

use Import::Modern;

use base qw(Rose::DB::Object::Metadata);

__PACKAGE__->column_type_class('geometry'          => 'Import::DB::Object::Metadata::Column::Geometry');
__PACKAGE__->column_type_class('postgis.geometry'  => 'Import::DB::Object::Metadata::Column::Geometry');
__PACKAGE__->column_type_class('geography'         => 'Import::DB::Object::Metadata::Column::Geography');
__PACKAGE__->column_type_class('postgis.geography' => 'Import::DB::Object::Metadata::Column::Geography');

1;
