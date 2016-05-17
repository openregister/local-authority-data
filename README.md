# Local-authority register data

Data for the alpha [local-authority register](http://local-authority.alpha.openregister.org), 
a list of local government organisations in the United Kingdom seeded with data from
legislation and [opendatacommunities.org](http://opendatacommunities.org/).

This is currently a single data file, but the process of establishing a custodian for the register may result in the data being split
to populate four separate registers for England, Scotland, Wales and Northern Ireland, each with their own custodian.

# Maps

This repository also includes a [map](map/map.tsv) for migrating references to local authorities found in other data sets to the [ISO-3166-2;GB](https://en.wikipedia.org/wiki/ISO_3166-2:GB) three character identifiers used by the register.

The map is built from a number of different sources:

* [address-custodian.tsv](map/address-custodian.tsv) — a mapping of the Local Land and Property custodian codes found in the National Address Gazetteer and OS AddressBase™, was constructed using data found in the [AddressBase local custodian codes documentation](https://www.ordnancesurvey.co.uk/docs/product-schemas/addressbase-products-local-custodian-codes.zip).
* [street-local-custodian-administrative-area.tsv](map/street-local-custodian-administrative-area.tsv) — Local Land and Property custodian codes and their administrative area names found in the National Address Gazetteer and OS AddressBase™.
* [opendatacommunities.tsv](map/opendatacommunities.tsv) – constructed from the http://opendatacommunities.org/ portal.
* [food-authorities.tsv](map/food-authorities.tsv) — extracted from the Food Standards Agency ratings data — see [food-data](https://github.com/openregister/food-data).
* [local_authority_contact_details.csv](map/local_authority_contact_details.csv) – downloaded from [local.direct.gov.uk/Data/](http://local.direct.gov.uk/Data/)
* [ons.tsv](map/ons.tsv) — extracted from OS Open Names


# Licence

The software in this project is covered by LICENSE file.

The register data is [© Crown copyright](http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/copyright-and-re-use/crown-copyright/)
and available under the terms of the [Open Government 3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) licence.
