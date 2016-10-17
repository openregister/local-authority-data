# merge and deduce local-authority.tsv as a one-off activity to seed the register data

# iso.tsv - hand made mappings from ISO-3166-2;GB list
# snac.tsv - lists SNAC data from localdirectgov
# ons.tsv - ONS local authority geography codes

local-authorities.tsv:	merge.py iso.tsv snac.tsv
	merge.py > $@

install:	local-authorities.tsv
	cp local-authorities.tsv ../data/local-authority
