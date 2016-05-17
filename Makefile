
SOURCES=\
	data/local-authority/local-authorities.tsv \
	map/local-custodian.tsv \
	map/opendatacommunities.tsv \
	map/local_authority_contact_details.csv \
	map/food-authorities.tsv

map/map.tsv:	bin/map.py $(SOURCES)
	bin/map.py > $@

map/food-authorities.tsv:
	curl -qs 'https://raw.githubusercontent.com/openregister/food-data/master/ratings/data/local-authority.tsv' > $@

map/local_authority_contact_details.csv:
	curl -qs 'http://local.direct.gov.uk/Data/local_authority_contact_details.csv' > $@

clobber:
	rm -f map/map.tsv

flake8:
	flake8 bin
