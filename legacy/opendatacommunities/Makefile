# Data constructed from the http://opendatacommunities.org/ portal.
# http://opendatacommunities.org/data/local-authorities
URL='http://opendatacommunities.org/resources.json?dataset=local-authorities&page=1&per_page=600&type_uri=http%3A%2F%2Fopendatacommunities.org%2Fdef%2Flocal-government%2FCivilAdministrativeAuthority'

local-authorities.json:
	curl -s $(URL) > $@
