# Local-authority register data

Data for the alpha [local-authority-eng register](http://local-authority-eng.alpha.openregister.org),
a list of local government organisations in England:

- [local-authority-eng](data/local-authority-eng/local-authorities.tsv)

This repository also includes data to populate four similar registers for Scotland, Wales and Northern Ireland, which are in discovery awaiting a custodian:

- [local-authority-sct](data/local-authority-sct/local-authorities.tsv)
- [local-authority-wls](data/local-authority-sct/local-authorities.tsv)
- [local-authority-nir](data/local-authority-nir/local-authorities.tsv)

# Identifier

The local-authority identifier has been constructed from the [ISO-3166-2;GB](https://en.wikipedia.org/wiki/ISO_3166-2:GB) three character identifier.

Separate local authority boundary registers will contain the boundary for each local-authority,
indexed by the [ONS/GSS](https://en.wikipedia.org/wiki/ONS_coding_system) geographical code, which changes when the boundary changes.

# Maps

This repository also includes a number of [maps](maps) intended to help migrate references to local authorities found in existing data and documents to the identifiers used by the register:

- [gss.tsv](maps/gss.tsv) — Office of National Statistics GSS coding system codes
- [snac.tsv](maps/snac.tsv) — ONS former hierarchical Standard Names and Codes (SNAC)
- [local-custodian.tsv](maps/local-custodian.tsv) — AddressBase™ / Geoplace LLP address custodian names and codes
- [edubase.tsv](maps/edubase.tsv) — Edubase local authority codes
- [food-standards.tsv](maps/food-standards.tsv) — local authority codes from the Food Standards Agency ratings data
- [os.tsv](maps/os.tsv) — Ordnance Survey county and other codes found in os-open-names data
- [gaz50k.tsv](maps/gaz50k.tsv) — Ordnance Survey county codes found in the 50k gazetteer
- [discovery.tsv](maps/discovery.tsv) — discovery register codes

# Licence

The software in this project is covered by LICENSE file.

The register data is [© Crown copyright](http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/copyright-and-re-use/crown-copyright/)
and available under the terms of the [Open Government 3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) licence.
