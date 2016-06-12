package Import::Model::Variable;

use strict;

use base qw(Import::DB::Object);

__PACKAGE__->meta->setup(
    table   => 'variables',

    columns => [
        id   => { type => 'serial', not_null => 1 },
        name => { type => 'varchar' },
        val  => { type => 'varchar' },
    ],

    primary_key_columns => [ 'id' ],

    unique_key => [ 'name' ],
);

1;

