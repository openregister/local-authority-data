TARGETS=\
	legacy/report.html \
	legacy/report.tsv

all:	$(TARGETS)

legacy/report.tsv:	legacy/report.html

legacy/report.html:	bin/legacy.rb
	bundle exec ruby bin/legacy.rb\
	&& bundle exec ruby bin/check.rb

clobber:
	rm -f $(TARGETS)
	rm -f legacy/names.tsv

flake8:
	flake8 bin

init:
	bundle install
