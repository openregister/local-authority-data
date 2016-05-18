require 'map_by_method'
require 'morph'
require 'yaml'

def load file
  puts ""
  puts file
  extension = File.extname(file)
  name = File.split(file).first.split('/').last
  # name = File.split(file).last.sub(extension,'')
  name.gsub!('-','_')
  puts name
  data = IO.read(file).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  list = Morph.send(:"from_#{extension.tr('.','')}", data, name)
  [name, list]
end

_, authorities = load Dir.glob('data/*/**').first ; nil

others = Dir.glob('legacy/*/*{tsv}').each_with_object({}) do |file, hash|
  name, list = load(file)
  hash[name.to_sym] = list
end ; nil

others[:local_directgov].delete_if do |item|
  item.snac.blank?
end ; nil

others[:opendatacommunities].delete_if do |item|
  item.ons_code.blank?
end ; nil

others.map do |name, list|
  puts ""
  puts name
  puts list.first.morph_attributes.to_yaml
  puts ""
  puts ""
end

names = authorities.map_by_name.sort ; nil
authorities.each {|item| item._id_attribute = :local_authority} ; nil

to_id = {
  food_standards: :food_authority,
  geoplace: :local_custodian,
  local_directgov: :snac,
  opendatacommunities: :ons_code,
  addressbase: :local_custodian
}

to_name = {
  food_standards: :name,
  geoplace: :name,
  local_directgov: :name,
  opendatacommunities: :local_authority_name,
  addressbase: :administrative_area
}

dataset_keys = others.keys.select{ |x| x != :os_open_names }

dataset_keys.each do |dataset|
  others[dataset].each do |item|
    item._name_attribute = to_name[dataset]
    item._id_attribute = to_id[dataset]
  end
end ; nil

def name_it item
  (item.try(:name) || item.send(item._name_attribute)).dup
end

def id_it item
  unless item._id_attribute == :name
    item.send(item._id_attribute).to_s.dup
  end
end

def normalize_name item
  name = name_it(item).dup
  name.strip!
  name.tr!(',', ' ')
  name.tr!('.', ' ')
  name.tr!('-', ' ')
  name.gsub!(/\s+/, ' ')
  name.sub!(' coucil', ' council')

  name.downcase!

  name.sub!(' & ', ' and ')

  [
    ['aberdeen c ity', 'aberdeen city'],
    ['aberdeen cuty', 'aberdeen city'],
    ['comhairle nan eilean siar (western isles)', 'comhairle nan eilean siar'],
    ['merthyr tudful', 'merthyr tydfil'],
    ['merthyr tydfil ua', 'merthyr tydfil'],
    ['rhondda cynon taff', 'rhondda cynon taf'],
  ].each do |replace, with|
    name.sub!(replace, with)
  end

  [
    'county borough council',
    'metropolitan district council',
    'metropolitan borough council',
    'borough council',
    'city council',
    'county council',
    'district council',
    'county borough',
    'council',
    'county of',
    'city of',
  ].each do |suffix|
    name.sub!(/\s#{suffix}$/, '')
  end
  name.sub!(/\sand$/, '')
  name.strip!

  name
end

by_name = [authorities, others.except(:os_open_names).except(:map).values].flatten.
  select{|item| !normalize_name(item)[/\s(fire|police)\s/] }.
  sort_by{|item| normalize_name(item) }.
  group_by{|item| normalize_name(item) } ; nil

puts by_name.keys

class_keys = [authorities.first.class] + dataset_keys.map{|k| others[k].first.class}

File.open('maps/out.html', 'w') do |f|
  f.write('<head>')
  f.write('<link href="https://govuk-elements.herokuapp.com/public/stylesheets/elements-page.css" rel="stylesheet" type="text/css">')
  f.write('</head>')
  f.write('<body>')
  f.write('<table>')
  f.write('<tr><th></th>')
  class_keys.each do |key|
    f.write('<th>' + key.name.downcase.sub('morph::','') + '</th>')
  end
  f.write('</tr>')

  by_name.each do |n, list|
    f.write('<tr><td><b>'+n+'</b></td>')
    class_keys.each do |key|
      item = list.detect {|i| i.class == key}
      if item
        f.write('<td>' + id_it(item) + ' | ' + name_it(item) + '</td>')
      else
        f.write('<td></td>')
      end
    end
    f.write('</tr>')
  end
  f.write('</table>')
  f.write('</body>')
end
puts by_name.keys.size

puts ""
puts "File written to map/out.html"
puts ""
