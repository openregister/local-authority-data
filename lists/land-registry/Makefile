local-authorities.tsv:
	curl -qs 'http://publicdata.landregistry.gov.uk/transaction-data/Number-of-applications-in-England-and-Wales-divided-by-local-authority-2016-04.csv' | grep -v 'Number of applications' | grep -v ',,,,,,,,,,,,' | grep -v Metrics | grep -v 'Calendar' | grep -v 'Total,' | grep -v 'ALL COUNTIES' | awk '{gsub(",","\t"); print;}' > $@
