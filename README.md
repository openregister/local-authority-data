# Local-authority register data

Data for the alpha [local-authority register](http://local-authority.alpha.openregister.org),
a list of local government organisations in the United Kingdom.

This is currently a single data file, but the process of establishing a custodian for the register may result in the data being split
to populate four separate registers for England, Scotland, Wales and Northern Ireland, each with their own custodian.

# Identifier

The local-authority identifier has been constructed from the [ISO-3166-2;GB](https://en.wikipedia.org/wiki/ISO_3166-2:GB) three character identifier.

A separate local-authority-boundary register will contain the boundary for each local-authority,
indexed by the [ONS/GSS](https://en.wikipedia.org/wiki/ONS_coding_system) geographical code, which changes when the boundary changes.

# Maps

This repository also includes a number of [maps](maps) intended to help migrate references to local authorities found in existing data and documents to the identifiers used by the register:

- [local-custodian.tsv](maps/local-custodian.tsv) — AddressBase™ / Geoplace LLP address custodian names and codes
- [edubase.tsv](maps/edubase.tsv) — Edubase local authority codes
- [food-standards.tsv](maps/food-standards.tsv) — local authority codes from the Food Standards Agency ratings data
- [snac.tsv](maps/snac.tsv) — ONS former hierarchical Standard Names and Codes (SNAC)
- [os.tsv](maps/os.tsv) — Ordnance Survey county and other codes found in os-open-names data
- [gss.tsv](maps/gss.tsv) — Office of National Statistics GSS coding system codes

# Licence

The software in this project is covered by LICENSE file.

The register data is [© Crown copyright](http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/copyright-and-re-use/crown-copyright/)
and available under the terms of the [Open Government 3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) licence.
