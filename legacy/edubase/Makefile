DATE:=$(shell date +"%Y%m%d")
URL=http://www.education.gov.uk/edubase/edubasealldata$(DATE).csv
CSV=cache/edubase.csv

local-authorities.tsv:	$(CSV) map.py
	map.py < $(CSV) > $@

cache/edubase.csv:
	@mkdir -p cache
	curl -s $(URL) | iconv -f ISO-8859-1 -t UTF-8 > $@

clean:
	rm -rf cache
