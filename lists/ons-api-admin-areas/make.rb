##
# To install dependencies:
#     bundle
#
# The ONS OpenAPI requires you register for an API key:
#     https://web.ons.gov.uk/ons/apiservice/web/apiservice/home
#
# To run please provide your ONS_APIKEY as an env var, like this:
#     ONS_APIKEY=<your-key> bundle exec ruby make.rb
#
require 'ons_openapi'

census = OnsOpenApi.context('Census')

list = []
list.push *census.geographies('2011WARDH', levels:'0,1,2,3,4,5,6').sort_by(&:item_code)
list.push *census.geographies('2012WARDH', levels:'0,1,2,3,4,5,6').sort_by(&:item_code)
list.push *census.geographies('2013WARDH', levels:'0,1,2,3,4,5,6').sort_by(&:item_code)
list.push *census.geographies('2014WARDH', levels:'0,1,2,3,4,5,6').sort_by(&:item_code)
by_item_code = list.sort_by(&:item_code).group_by(&:item_code)

def add! tsv, item_code_group
  item = item_code_group.first
  item_code_group.each do |x|
    if item.label != x.label
      raise x.label + ' ' + item.label
    end
  end
  cy_label = item.labels.labels.detect{|l| l.xml_lang[/cy/]}.text
  cy_label = nil if item.label == cy_label
  tsv << [
    item.item_code,
    item.parent_code,
    item.label,
    cy_label,
    item.area_type.abbreviation,
    item.area_type.codename,
    item.area_type.level,
    item_code_group.map(&:geography_code).sort.reverse.join(',')
  ].join("\t")
end

tsv = []
headers = ['item-code','parent-code','name', 'name-cy', 'area-type', 'area-type-name', 'area-type-level', 'geography-codes'].join("\t")
by_item_code.each do |code, group|
  group.group_by(&:label).each do |label, list|
    add! tsv, list
  end
end

puts "Writing out tsv file: ward-hierarchy.tsv"
File.open("ward-hierarchy.tsv",'w') do |f|
  f.write headers
  f.write "\n"
  f.write tsv.join("\n")
end
