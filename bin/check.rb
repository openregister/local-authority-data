require 'morph'
require 'net/http'
require 'yaml'

def load_lists_report
  unless File.exist?("./lists/report.tsv")
    `bundle exec ruby bin/lists_report.rb`
  end
  data = Morph.from_tsv IO.read("./lists/report.tsv"), 'LocalAuthority'
  by_local_authority = data.group_by(&:local_authority)
  by_local_authority.delete("")
  by_local_authority
end

def load_map_file file
  data = Morph.from_tsv IO.read("./maps/#{file}.tsv"), 'LocalAuthority'
  by_local_authority = data.group_by(&:local_authority)
  by_local_authority.delete("")
  by_local_authority
end

def map_key key
  case key
  when :gss
    :os_boundary_line
  when :iso_code
    :iso
  when :local_custodian
    :geoplace
  when :os
    :os_open_names
  when :snac
    :local_directgov
  else
    key
  end
end

def known_report_exception? key, expected
  expected.try(:name).to_s[/MISSING/] ||
  (key == :gss && expected.try(key).to_s[/^N.*/])
end

lists_mapping = load_lists_report
lists = %w[
  edubase
  food-authority
  gaz50k
  gss
  iso-code
  local-custodian
  opendatacommunities
  os
  snac
]

lists.each do |list|
  puts ""
  puts ""
  print list
  data_by_local_authority = load_map_file(list)
  print ": expect mapping for #{data_by_local_authority.count} files"

  key = list.gsub('-','_').to_sym

  lists_mapping.keys.each do |local_authority|
    expected = data_by_local_authority[local_authority].try(:first)
    automated = lists_mapping[local_authority]
    automated = automated.first if automated.is_a?(Array)

    begin
      if expected && automated && expected.send(key).to_s == automated.send(map_key(key)).to_s.split(';').uniq.last.to_s
        # print '.'
      elsif expected.nil? && automated.try(map_key(key)).blank?
        # print '-'
      elsif expected && map_key(key) == :geoplace && automated.send(:addressbase).split(';').uniq.include?(expected.send(key))
        # print '~'
      elsif !known_report_exception?(key, expected)
        puts ""
        puts "---"
        puts "local_authority: #{local_authority}"
        puts "expected match:  #{expected.to_yaml}"
        puts "automated match: #{automated.to_yaml}"
        puts ""
        expected_key = expected.try(key)
        automated_match_key = automated.try(map_key(key))

        msg = ["whoah! for local_authority", "'#{local_authority}'",
          list,
          "expected", "'#{expected_key}'", "got", "'#{automated_match_key}'"].join("\t")
        puts ""
        if (expected && expected.local_authority == "local-authority-eng:GLA")
          puts msg
        else
          raise msg
        end
        puts ""
      end
    rescue Exception => e
      raise e
    end
  end
  puts " ... passed ok"

end
puts ""
