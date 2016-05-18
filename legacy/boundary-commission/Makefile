URL='https://www.lgbce.org.uk/__data/assets/excel_doc/0003/25563/Summary-of-all-English-Councils-2015-10-20.xlsx'
XLSX=english-councils.xlsx

local-authorities.tsv:	$(XLSX) map.py
	map.py $(XLSX) > $@

$(XLSX):
	curl -qs $(URL) > $@
