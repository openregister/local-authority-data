
street-administrative-area.tsv:
	( \
		echo "street-administrative-area" \
		&& csvcut -tc town-administrative-area \
		../../../address-discovery-data-matching/data/town-administrative-area-count.tsv \
		| sed 's/^.*\|//g' \
		| sort -u \
		| grep -v town-administrative-area \
	) > $@
