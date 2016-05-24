SOURCES=\
	data/local-authority/local-authorities.tsv \
	legacy/geoplace/local-custodian.tsv \
	legacy/opendatacommunities/opendatacommunities.tsv \
	legacy/food-standards/local-authorities.tsv

all:	maps/map.tsv legacy/report.html

maps/map.tsv:	bin/map.py $(SOURCES)
	bin/map.py > $@

legacy/report.html:	bin/map.rb
	bundle exec ruby bin/map.rb

clobber:
	rm -f map/map.tsv

flake8:
	flake8 bin

init:
	bundle install
