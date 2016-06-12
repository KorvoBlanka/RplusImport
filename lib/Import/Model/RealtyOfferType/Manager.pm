package Import::Model::RealtyOfferType::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use Import::Model::RealtyOfferType;

sub object_class { 'Import::Model::RealtyOfferType' }

__PACKAGE__->make_manager_methods('realty_offer_types');

1;

