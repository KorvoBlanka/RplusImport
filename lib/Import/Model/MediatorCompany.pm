package Import::Model::MediatorCompany;

use strict;

use base qw(Import::DB::Object);

__PACKAGE__->meta->setup(
    table   => 'mediator_companies',

    columns => [
        id          => { type => 'serial', not_null => 1 },
        name        => { type => 'varchar', length => 64, not_null => 1, remarks => 'Название' },
        add_date    => { type => 'timestamp with time zone', default => 'now()', not_null => 1, remarks => 'Дата/время добавления' },
        delete_date => { type => 'timestamp with time zone', remarks => 'Дата/время удаления' },
    ],

    primary_key_columns => [ 'id' ],

    allow_inline_column_values => 1,

    relationships => [
        mediators => {
            class      => 'Import::Model::Mediator',
            column_map => { id => 'company_id' },
            type       => 'one to many',
        },
    ],
);

1;

