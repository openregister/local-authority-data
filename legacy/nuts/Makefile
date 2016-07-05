# Data from http://ec.europa.eu/eurostat/ramon/nomenclatures/index.cfm?TargetUrl=LST_CLS_DLD&StrNom=NUTS_2013L&StrLanguageCode=EN&StrLayoutCode=HIERARCHIC#
URL='http://ec.europa.eu/eurostat/ramon/nomenclatures/index.cfm?TargetUrl=ACT_OTH_CLS_DLD&StrNom=NUTS_2013L&StrFormat=CSV&StrLanguageCode=EN&IntKey=&IntLevel=&bExport='

local-authorities.tsv:	 nuts.csv map.py
	map.py < nuts.csv > $@

nuts.csv:
	curl -qs $(URL) | tr '\r' '\n' | sed -e 's/;/,/g' > $@
