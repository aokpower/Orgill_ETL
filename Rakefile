require 'awesome_print'

require_relative 'lib/orgill/products/leg_source'
require_relative 'lib/orgill/products/leg_map'

task :legsource do
  file   = 'ign/WEB_SKU_COMMON_EXAMPLE.TXT'
  map    = Orgill::Products::WEB_SKU_COMMON_MAP
  source = Orgill::Products::LegSource.new(file: file, index_map: map)
  source.each { |p| ap(p) }
end

task :add_headers_to do
  require 'csv'

  map    = Orgill::Products::WEB_SKU_COMMON_MAP
  # transform web_sku_map into in order array of headers
  headers = []
  map.size.times do |n|
    # Can't use #reduce because hashes are order independant.
    headers << map[n]
  end

  products = Orgill::Products::LegSource.detabularize(File.read(ARGV[1]))

  CSV.open(ARGV[2], 'w') do |out|

    out << headers
    products.each { |product| out << product }
  end
end

task default: [:legsource]
