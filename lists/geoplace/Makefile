# Local Land and Property custodian codes found in the National Address Gazetteer and OS AddressBase™
ZIP_URL='https://www.ordnancesurvey.co.uk/docs/product-schemas/addressbase-products-local-custodian-codes.zip'
ZIP='addressbase-products-local-custodian-codes.zip'
PDF_URL='https://www.geoplace.co.uk/documents/10181/128365/2014%20NLPG%20DEC%20v.3.3%20clean'
PDF='NLPGv.3.3.pdf'

all:	$(ZIP) $(PDF)

# hard to script extracting codes from the .docx document
$(ZIP):
	curl -qs $(ZIP_URL) > $@

# .. or from this older, more complete PDF
$(PDF):
	curl -qs '$(PDF_URL)' > $@
