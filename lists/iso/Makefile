
target: second_level_divisions.tsv

second_level_divisions.tsv: cache/source.html lib/iso.rb
	bundle exec ruby lib/iso.rb

cache/source.html:
	@mkdir -p cache
	curl -qs https://en.wikipedia.org/wiki/ISO_3166-2:GB > $@

clean:
	rm -f cache/source.html
	rm -f second_level_divisions.tsv

init:
	bundle install
