TARGETS=\
	lists/report.html \
	lists/report.tsv

all:	$(TARGETS)

lists/report.tsv:	lists/report.html

lists/report.html:	bin/lists_report.rb
	bundle exec ruby bin/lists_report.rb\
	&& bundle exec ruby bin/check.rb

clobber:
	rm -f $(TARGETS)
	rm -f lists/names.tsv

init:
	bundle install
