# Local Land and Property custodian codes found in the National Address Gazetteer and OS AddressBase™
URL='https://www.ordnancesurvey.co.uk/docs/product-schemas/addressbase-products-local-custodian-codes.zip'
ZIP='addressbase-products-local-custodian-codes.zip'

local-authorities.tsv:	$(ZIP)
	funzip $(ZIP) > x

$(ZIP):
	curl -qs $(URL) > $@
