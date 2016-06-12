package Import::Model::Mediator;

use strict;

use base qw(Import::DB::Object);

__PACKAGE__->meta->setup(
    table   => 'mediators',

    columns => [
        id             => { type => 'serial', not_null => 1 },
        company_id     => { type => 'integer', not_null => 1, remarks => 'Компания' },
        name           => { type => 'varchar', length => 64, remarks => 'Кому принадлежит номер (Агент/Офис/и т.д.)' },
        phone_num      => { type => 'varchar', length => 10, not_null => 1, remarks => 'Номер телефона' },
        add_date       => { type => 'timestamp with time zone', default => 'now()', not_null => 1, remarks => 'Дата/время добавления' },
        delete_date    => { type => 'timestamp with time zone', remarks => 'Дата/время удаления' },
        last_seen_date => { type => 'timestamp with time zone', default => 'now()', not_null => 1, remarks => 'дата, когда последний раз этот посредник появлялся в изданиях' },
    ],

    primary_key_columns => [ 'id' ],

    allow_inline_column_values => 1,

    foreign_keys => [
        company => {
            class       => 'Import::Model::MediatorCompany',
            key_columns => { company_id => 'id' },
        },
    ],
);

1;

