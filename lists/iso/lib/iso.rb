require 'nokogiri'

doc = Nokogiri::HTML File.read('./cache/source.html') ; nil

rows = doc.
  search('table.wikitable')[2].
  search('tr').
  slice(1..-1).
  map do |tr|
    row = tr.text.strip.split("\n")
    bs_6879 = row[0].sub('GB-','')
    row.insert(1, bs_6879)
  end ; nil

headers = %w[iso-code bs-6879 name category parent].join("\t")

File.open('second_level_divisions.tsv', 'w') do |f|
  f.write headers + "\n"
  rows.each {|r| f.write r.join("\t") + "\n"}
end
