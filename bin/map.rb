require 'map_by_method'
require 'morph'
require 'yaml'

def load_meta file
  dir = File.split(file).first
  meta = File.join(dir, 'meta.yml')
  YAML.load_file(meta).each_with_object({}) do |x, h|
    h[x.first.to_sym] = x.last.sub('-','_').downcase.to_sym
  end
end

def name_from file
  extension = File.extname(file)
  name = File.split(file).first.split('/').last.gsub('-','_')
  [name, extension]
end

def load_data name, extension, file
  data = IO.read(file).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  Morph.send(:"from_#{extension.tr('.','')}", data, name)
end

def load file
  name, extension = name_from(file)
  puts "\n#{file}\n#{name}"
  list = load_data(name, extension, file)
  meta = load_meta(file)
  klass = list.first.class
  klass.class_eval("def _name; send(:#{meta[:name]}); end")
  klass.class_eval("def _id; send(:#{meta[:id]}); end")
  [name, list]
end

def load_data_and_legacy
  _, data = load Dir.glob('data/*/*{tsv}').first ; nil

  legacy = Dir.glob('legacy/*/*{tsv}').each_with_object({}) do |file, hash|
    name, list = load(file)
    hash[name.to_sym] = list
  end ; nil

  [data, legacy]
end

def remove_unrelated! legacy
  legacy[:local_directgov].delete_if { |item| item.snac.blank? }; nil
  legacy[:opendatacommunities].delete_if { |item| item.ons_code.blank? }; nil
end

def log_legacy legacy
  legacy.map do |name, list|
    puts ""
    puts name
    puts [list.first._id, list.first._name].join(" | ")
    puts list.first.morph_attributes.to_yaml
    puts ""
    puts ""
  end
end

def fix_mispelling! name
  name.sub!(' coucil', ' council')
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
end

def remove_suffix! name
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
end

def normalize_name item
  name = item._name.dup
  name.strip!
  name.tr!(',', ' ')
  name.tr!('.', ' ')
  name.tr!('-', ' ')
  name.gsub!(/\s+/, ' ')
  name.downcase!
  name.sub!(' & ', ' and ')

  fix_mispelling! name
  remove_suffix! name

  name.sub!(/\sand$/, '')
  name.strip!
  name
end

def group_by_normalize_name authorities, legacy
  legacy_values = legacy.except(:os_open_names).except(:map).values
  by_name = [authorities, legacy_values].flatten.
    select{|item| !normalize_name(item)[/\s(fire|police)\s/] }.
    sort_by{|item| normalize_name(item) }.
    group_by{|item| normalize_name(item) }
end

def class_keys authorities, legacy
  dataset_keys = legacy.keys.select{ |x| x != :os_open_names }
  [authorities.first.class] + dataset_keys.map{|k| legacy[k].first.class}
end

def write_to_html authorities, legacy, by_name
  class_keys = class_keys authorities, legacy
  File.open('maps/out.html', 'w') do |f|
    f.write('<!DOCTYPE html>')
    f.write("\n")
    f.write('<html><head>')
    f.write("\n")
    f.write('<meta http-equiv="content-type" content="text/html; charset=utf-8">')
    f.write("\n")
    f.write('<link href="https://govuk-elements.herokuapp.com/public/stylesheets/elements-page.css" rel="stylesheet" type="text/css">')
    f.write('<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.0.0-beta1/jquery.min.js" type="text/javascript"></script>')
    f.write('<script src="https://cdnjs.cloudflare.com/ajax/libs/floatthead/1.4.0/jquery.floatThead.min.js" type="text/javascript"></script>')
    f.write("\n")
    f.write('</head>')
    f.write("\n")
    f.write('<body>')
    f.write('<table>')
    f.write("\n")
    f.write('<thead>')
    f.write("\n")
    f.write('<tr><th style="background: lightgrey;"></th>')
    class_keys.each do |key|
      f.write('<th style="background: lightgrey;">' + key.name.downcase.sub('morph::','') + '</th>')
    end
    f.write('</tr>')
    f.write("\n")
    f.write('</thead>')
    f.write('<tbody>')

    by_name.each do |n, list|
      f.write("\n")
      f.write('<tr><td><b>'+n+'</b></td>')
      class_keys.each do |key|
        items = list.select {|i| i.class == key}
        f.write('<td>')
        value = items.sort_by(&:_id).map do |item|
          if item._id == item._name
            item._id
          else
            item._id + ' | ' + item._name
          end
        end.join('<br />')
        f.write(value)
        f.write('</td>')
      end
      f.write('</tr>')
    end
    f.write("\n")
    f.write('</tbody>')
    f.write('</table>')
    f.write("\n")
    f.write('<script type="text/javascript">$("table").floatThead({position: "fixed"});</script>')
    f.write("\n")
    f.write('</body></html>')
  end

  puts ""
  puts "File written to map/out.html"
  puts ""
end

authorities, legacy = load_data_and_legacy
remove_unrelated! legacy

log_legacy legacy

by_name = group_by_normalize_name(authorities, legacy) ; nil

write_to_html authorities, legacy, by_name
