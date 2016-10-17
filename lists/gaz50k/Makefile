# Data from the OS 50k Gazetteer
# https://www.ordnancesurvey.co.uk/business-and-government/products/50k-gazetteer.html
# used under the terms of the Open Government Licence

# hard to automate this download due to a register-wall
ZIP=gaz50k_gb.zip
TXT=cache/50kgaz2016.txt

local-authorities.tsv: $(TXT) map.py
	map.py < $(TXT) > $@

$(TXT):	$(ZIP)
	mkdir -p cache
	unzip -p $(ZIP) Data/50kgaz2016.txt | iconv -f ISO-8859-1 -t UTF-8 > $@

clean:
	rm -rf cache
