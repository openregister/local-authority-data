# Data from http://local.direct.gov.uk/Data/
URL='http://local.direct.gov.uk/Data/local_authority_contact_details.csv'

local-authorities.tsv:	local_authority_contact_details.csv map.py
	iconv -t UTF-8 -f ISO-8859-1 < local_authority_contact_details.csv | map.py > $@

local_authority_contact_details.csv:
	curl -qs $(URL) > $@
