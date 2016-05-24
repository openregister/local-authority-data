# Data from OS, made accessible by MySociety: http://parlvid.mysociety.org/os/
URL='http://parlvid.mysociety.org/os/bdline_gb-2016-05.zip'
ZIP=cache/bdline_gb-2016-05.zip

local-authority.tsv:	county.csv district.csv map.py
	map.py > $@

district.csv:	district.shp district.shx district.dbf district.prj
	ogr2ogr -f CSV $@ district.shp

county.csv:	county.shp county.shx county.dbf county.prj
	ogr2ogr -f CSV $@ county.shp

county.shp:	$(ZIPFILE)
	unzip -p $(ZIP) Data/GB/county_region.shp > $@

county.dbf:	$(ZIPFILE)
	unzip -p $(ZIP) Data/GB/county_region.dbf > $@

county.prj:	$(ZIPFILE)
	unzip -p $(ZIP) Data/GB/county_region.prj > $@

county.shx:	$(ZIPFILE)
	unzip -p $(ZIP) Data/GB/county_region.shx > $@

district.shp:	$(ZIPFILE)
	unzip -p $(ZIP) Data/GB/district_borough_unitary_region.shp > $@

district.shx:	$(ZIPFILE)
	unzip -p $(ZIP) Data/GB/district_borough_unitary_region.shx > $@

district.dbf:	$(ZIPFILE)
	unzip -p $(ZIP) Data/GB/district_borough_unitary_region.dbf > $@

district.prj:	$(ZIPFILE)
	unzip -p $(ZIP) Data/GB/district_borough_unitary_region.prj > $@

$(ZIP):
	mkdir -p cache
	curl -qs $(URL) > $@
