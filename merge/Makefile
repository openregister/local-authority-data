# merge and deduce local-authority.tsv

# iso.tsv - hand made mappings from ISO-3166-2;GB list
# snac.tsv - legacy SNAC data from localdirectgov
# ons.tsv - ONS local authority geography codes

local-authorities.tsv:	merge.py iso.tsv snac.tsv
	merge.py > $@
