
SOURCES=\
	data/local-authority/local-authorities.tsv \
	legacy/geoplace/local-custodian.tsv \
	legacy/opendatacommunities/opendatacommunities.tsv \
	legacy/food-standards/local-authorities.tsv

maps/map.tsv:	bin/map.py $(SOURCES)
	bin/map.py > $@

clobber:
	rm -f map/map.tsv

flake8:
	flake8 bin
