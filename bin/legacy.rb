##
# To install dependencies:
#     bundle
#
# To run:
#     bundle exec ruby bin/legacy.rb
#
require 'builder'
require 'map_by_method'
require 'morph'
require 'yaml'

def load_meta file
  dir = File.split(file).first
  meta = File.join(dir, 'meta.yml')
  YAML.load_file(meta).each_with_object({}) do |x, h|
    h[x.first.to_sym] = x.last.gsub('-','_').downcase.to_sym
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
  list = load_data(name, extension, file)
  meta = load_meta(file)
  puts "\n#{file}\n#{name}\n#{meta.inspect}"
  klass = list.first.class
  klass.class_eval("def _name; send(:#{meta[:name]}); end")
  klass.class_eval("def _name=(val); send(:#{meta[:name]}=, val); end")
  klass.class_eval("def _id; send(:#{meta[:id]}); end")
  type = meta[:type] ? "send(:#{meta[:type]}).strip" : 'nil'
  klass.class_eval("def _type; #{type}; end")
  dataset = klass.name.sub('Morph::','').downcase
  klass.class_eval("def _dataset; '#{dataset}'; end")
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
  legacy[:ons_api_admin_areas].delete_if do |item|
    ['England and Wales',
    'Region',
    'Inner and Outer London',
    'Country',
    'Metropolitan County',
    'United Kingdom'].include?(item._type)
  end; nil
end

def log_legacy legacy
  legacy.map do |name, list|
    puts ""
    puts name
    puts list.first.morph_attributes.to_yaml
    puts [list.first._id, list.first._name].join(" | ")
    puts ""
    puts ""
  end
end

def fix_mispelling! name
  name.sub!(' coucil', ' council')
  name.sub!('comhairle nan eilean siar (western isles)', 'eilean siar')

  [
    ['blackburn', 'blackburn with darwen'],
    ['east dunbarton', 'east dunbartonshire'],
    ['shetland', 'shetland islands'],
    ['orkney', 'orkney islands'],
    ['anglesey', 'isle of anglesey'],
    ['highlands', 'highland'],
    ['scottish borders', 'the scottish borders'],
    ['county of herefordshire', 'herefordshire'],
    ['city and county of the city of london', 'city of london'],
    ['na h eileanan an iar', 'eilean siar'],
    ['eilean', 'eilean siar'],
    ['comhairle nan eilean siar', 'eilean siar'],
    ['western isles', 'eilean siar'],
    ['clackmannan', 'clackmannanshire'],
    ['armagh banbridge and craigavon', 'armagh city banbridge and craigavon'],
    ['city and county of swansea council', 'swansea'],
    ['derry and strabane', 'derry city and strabane'],
    ['durham', 'county durham'],
    ['durham county council', 'county durham'],
    ['newcastle city council', 'newcastle upon tyne'],
    ['north down and ards', 'ards and north down'],
    ['hull city council', 'kingston upon hull'],
    ['hull city', 'kingston upon hull'],
    ['north west somerset', 'north somerset'],
    ['pen y bont ar ogwr', 'bridgend'],
    ['the highland council', 'highland'],
    ['vale of glamorgan council', 'the vale of glamorgan'],
    ['vale of glamorgan', 'the vale of glamorgan'],
    ['ynys mn', 'isle of anglesey']
  ].each do |pattern, replace|
    name.sub!(/^#{pattern}$/, replace)
  end

  [
    ['aberdeen c ity', 'aberdeen city'],
    ['aberdeen cuty', 'aberdeen city'],
    ['blaenau gwent blaenau gwent', 'blaenau gwent'],
    ['borough council of', ''],
    ['ease dunbartonshire',  'east dunbartonshire'],
    ['east dunbaronshire',   'east dunbartonshire'],
    ['east dunnbartonshire', 'east dunbartonshire'],
    ['london borough of', ''],
    ['royal borough of', ''],
    ['borough of', ''],
    ['bradford mdc', 'bradford'],
    ['bristol city of', 'bristol'],
    ['(city of)', ''],
    ['the city of', ''],
    ['city of', ''],
    ['highands', 'highland'],
    ['london corporation', 'london'],
    ['comhairle nan eilean siar (western isles)', 'comhairle nan eilean siar'],
    ['merthyr tudful', 'merthyr tydfil'],
    ['merthyr tydfil ua', 'merthyr tydfil'],
    ["king's lynn and west norfolk", 'kings lynn and west norfolk'],
    ['rhondda cynon taff', 'rhondda cynon taf'],
    ['south ayshire', 'south ayrshire'],
    ['south buckinghamshire', 'south bucks'],
    # welsh to english ->
    ['abertawe', 'swansea'],
    ['blaenau gwent', 'blaenau gwent'],
    ['bro morgannwg', 'the vale of glamorgan'],
    ['caerdydd', 'cardiff'],
    ['caerffili', 'caerphilly'],
    ['casnewydd', 'newport'],
    ['castell-nedd port talbot', 'neath port talbot'],
    ['castell nedd port talbot', 'neath port talbot'],
    ['conwy', 'conwy'],
    ['gwynedd', 'gwynedd'],
    ['merthyr tudful', 'merthyr tydfil'],
    ['pen-y-bont ar ogwr', 'bridgend'],
    ['powys', 'powys'],
    ['rhondda cynon taf', 'rhondda cynon taf'],
    ['sir benfro', 'pembrokeshire'],
    ['sir ceredigion', 'ceredigion'],
    ['sir ddinbych', 'denbighshire'],
    ['sir fynwy', 'monmouthshire'],
    ['sir gaerfyrddin', 'carmarthenshire'],
    ['sir y fflint', 'flintshire'],
    ['sir ynys mon', 'isle of anglesey'],
    ['tor-faen', 'torfaen'],
    ['wrecsam', 'wrexham']
    # <- welsh to english
  ].each do |replace, with|
    name.sub!(replace, with)
  end
end

def remove_suffix! name
  [
    '\(b\)',
    'county borough council',
    'metropolitan district council',
    'metropolitan borough council',
    'borough council',
    'county council',
    'city and district council',
    'district council',
    'county borough',
    'council',
    'county of',
    'city of',
    'district',
    'london boro',
    'city',
    'county'
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
  legacy_values = legacy.except(:map).values
  legacy[:os_boundary_line].each {|item| item._name = item._name.split(" - ").last }
  legacy[:os_open_names].each {|item| item._name = item._name.split(" - ").last }

  by_name = [authorities, legacy_values].flatten.
    select{|item| !normalize_name(item)[/\s(fire|police)\s/] }.
    sort_by{|item| normalize_name(item) }.
    group_by{|item| normalize_name(item) }
end

def class_keys authorities, legacy
  dataset_keys = legacy.keys
  [authorities.first.class] + dataset_keys.map{|k| legacy[k].first.class}
end

def css_class value
  type = value.to_s.downcase.sub(' ','-')
  type.blank? ? 'other' : type
end

def class_matches(list, key)
  list.select {|i| i.class == key}
end

def local_authority_from(list)
  list.detect {|i| i.class == Morph::LocalAuthority}
end

def write_to_html class_keys, by_name, dataset_to_type
  b = Builder::XmlMarkup.new(indent: 2)
  html = b.html {
    b.head {
      b.meta('http-equiv': "content-type", content: "text/html; charset=utf-8")
      b.script(src: "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.0.0-beta1/jquery.min.js", type: "text/javascript")
      b.script(src: "https://cdnjs.cloudflare.com/ajax/libs/floatthead/1.4.0/jquery.floatThead.min.js", type: "text/javascript")
      b.link(href: "https://govuk-elements.herokuapp.com/public/stylesheets/elements-page.css", rel: "stylesheet", type: "text/css")
      b.style({type: "text/css"}, '
        a { color: inherit; }
        table th, table td { font-size: 12px; }
        .city-corporation, .cty, two-tier-county      { color: #d53880; }
        .council-area, .ca           { color: #f47738; }
        .district, .dis              { color: #006435; }
        .london-borough, .lob        { color: #912b88; }
        .metropolitan-district, .md  { color: #85994b; }
        .two-tier-district, .nmd       { color: #B10E1E; }
        .unitary-authority, .ua      { color: #2b8cc4; }
        .other                       { color: #6F777B; }
      ')
    }
    b.body {
      b.table {
        b.thead {
          b.tr {
            b.th style: "background: lightgrey;"
            b.th style: "background: lightgrey;"
            class_keys.each do |key|
              b.th({style: "background: lightgrey;"}, key.name.downcase.sub('morph::','') )
            end
          }
        }
        b.tbody {
          b.tr {
            b.td ''
            b.td ''
            class_keys.each do |key|
              b.td {
                dataset = key.name.downcase.sub('morph::','')
                if types = dataset_to_type[dataset]
                  b.ul {
                    types.to_a.sort_by{|x| x.first.downcase}.each do |label, value|
                      b.li({class: css_class(value)}, label)
                    end
                  }
                end
              }
            end
          }
          all = by_name.to_a
          first = all.delete_at(0)
          all.insert(-1, first)
          all.each do |n, list|
            b.tr {
              b.td {
                b.b(n)
                end_date = local_authority_from(list).try(:end_date)
                if end_date
                  b.span(" | end_date:" + end_date.to_s)
                end
              }
              b.td { b.b( local_authority_from(list).try(:uk).to_s) }
              class_keys.each do |key|
                values = class_matches(list, key).map do |item|
                  value = item._id
                  value += ' | ' + item._name unless item._id == item._name
                  type = 'unknown'
                  if item._type
                    value += ' | ' + item._type
                    type = css_class(dataset_to_type[item._dataset][item._type])
                  end
                  url = nil
                  if item._dataset == 'legislation'
                    url = item.legislation_gov_uk_reference
                  end
                  [value, type, url]
                end.uniq
                b.td {
                  b.ul {
                    values.sort.map do |value, type, url|
                      if url
                        b.li({class: type}) {
                          b.a({href: url, rel: 'external'}, value)
                        }
                      else
                        b.li({class: type}, value)
                      end
                    end
                  }
                }
              end
            }
          end
        }
      }
      b.script({ type: "text/javascript"}, '$("table").floatThead({position: "fixed"});')
    }
  }
  html = html.to_s
  html.gsub!('type="text/javascript"/>','type="text/javascript"></script>')
  file = 'legacy/report.html'
  File.open(file, 'w') do |f|
    f.write('<!DOCTYPE html>')
    f.write("\n")
    f.write(html)
    f.write("\n")
  end
  puts "\nFile written to #{file}\n"
end

def write_to_report_tsv class_keys, by_name
  puts 'Write file to: legacy/report.tsv'
  File.open('legacy/report.tsv', 'w') do |f|
    class_keys.each do |key|
      header = key.name.sub('Morph::','').underscore.gsub('_','-')
      header = 'food-authority' if header[/food-standards/]
      f.write(header)
      f.write("\t")
      f.write(header + '-name')
      f.write("\t")
    end
    f.write("\n")
    by_name.each do |n, list|
      next if n.blank?
      class_keys.each do |key|
        values = class_matches(list, key).map do |item|
          value = item._id
        end.join(';')
        f.write(values)
        f.write("\t")
        names = class_matches(list, key).map do |item|
          if item._id != item._name
            value = item._name
          else
            ''
          end
        end.join(';')
        f.write(names)
        f.write("\t")
      end
      f.write("\n")
    end
  end
end

def normalize_name_for_maps name
  name = name.downcase
  name.gsub!('&', 'and')
  name.gsub!(/\s+/, ' ')
  name.strip!
  name.chomp!(' (b)')
  name
end

def write_to_name_tsv class_keys, by_name
  puts 'Write file to: legacy/name.tsv'
  File.open('legacy/name.tsv', 'w') do |f|
    f.write('name')
    f.write("\t")
    f.write('local-authority')
    f.write("\n")

    name_hash = {}
    by_name.each do |n, list|
      next if n.blank?
      local_authority = local_authority_from(list)
      next if local_authority.blank?
      class_keys.each do |key|
        names = class_matches(list, key).map { |item| item._name }
        names.each do |name|
          name_hash[normalize_name_for_maps(name)] = local_authority.local_authority
        end
      end
    end
    name_hash.keys.sort.each do |name|
      unless name.blank?
        f.write(name)
        f.write("\t")
        f.write(name_hash[name])
        f.write("\n")
      end
    end
  end
end

authorities, legacy = load_data_and_legacy ; nil
remove_unrelated! legacy ; nil

log_legacy legacy

by_name = group_by_normalize_name(authorities, legacy) ; nil

type_to_aliases = by_name.to_a.map {|key, list| list.each_with_object({}) {|item, hash| if type = item.try(:_type) ; hash[item._dataset] = type ; end } }.uniq.select {|x| x.size > 1}.group_by{|x| x['localauthority']}

dataset_to_type = type_to_aliases.to_a.each_with_object({}) {|to_alias, h| mapping = to_alias.last ; type = to_alias.first ; mapping.each {|submap| submap.keys.each {|dataset| h[dataset] ||= {}; h[dataset][submap[dataset]] = type} } }
dataset_to_type['localauthority']['district'] = 'district'
dataset_to_type['legislation']['Local Government District'] = 'district'
dataset_to_type['boundarycommission']['two-tier district'] = 'two-tier-district'
dataset_to_type['boundarycommission']['unitary district'] = 'unitary-authority'
dataset_to_type['onsapiadminareas']['Non-metropolitan District'] = 'nmd'
dataset_to_type['opendatacommunities']['District Council'] = 'nmd'
dataset_to_type['onsapiadminareas']['Unitary Authority'] = 'unitary-authority'
dataset_to_type['opendatacommunities']['Unitary Authority'] = 'unitary-authority'

class_keys = class_keys authorities, legacy
write_to_html class_keys, by_name, dataset_to_type
write_to_report_tsv class_keys, by_name
write_to_name_tsv class_keys, by_name
