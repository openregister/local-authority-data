
target: second_level_divisions.tsv

second_level_divisions.tsv: cache/source.html bundle
	[[ -e $@ ]] || \
	bundle exec ruby lib/iso.rb

bundle:
	[[ -e Gemfile.lock ]] || bundle install

cache/source.html:
	mkdir -p cache
	[[ -e $@ ]] || \
	curl -qs https://en.wikipedia.org/wiki/ISO_3166-2:GB > $@

clean:
	rm -f cache/source.html
	rm -f second_level_divisions.tsv
