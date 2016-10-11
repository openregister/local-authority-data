require 'morph'
require 'net/http'
require 'yaml'

def load_legacy_report
  unless File.exist?("./legacy/report.tsv")
    `bundle exec ruby bin/legacy.rb`
  end
  data = Morph.from_tsv IO.read("./legacy/report.tsv"), 'LocalAuthority'
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
  when :local_custodian
    :geoplace
  when :os
    :os_open_names
  when :gss
    :os_boundary_line
  else
    key
  end
end

def known_report_exception? key, expected
  expected.try(:name)[/MISSING/] ||
  (key == :gss && expected.try(key)[/^N.*/])
end

legacy_mapping = load_legacy_report
lists = %w[ edubase food-authority local-custodian gss os ]

lists.each do |list|
  puts ""
  puts ""
  print list
  data_by_local_authority = load_map_file(list)
  print ": expect mapping for #{data_by_local_authority.count} files"

  key = list.gsub('-','_').to_sym

  legacy_mapping.keys.each do |local_authority|
    expected = data_by_local_authority[local_authority].try(:first)
    automated = legacy_mapping[local_authority]
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
        raise msg
        puts ""
      end
    rescue Exception => e
      raise e
    end
  end
  puts " ... passed ok"

end
puts ""
