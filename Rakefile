require 'awesome_print'

require_relative 'lib/orgill/products/leg_source'
require_relative 'lib/orgill/products/leg_map'

task :legsource do
  file   = 'ign/WEB_SKU_COMMON_EXAMPLE.TXT'
  map    = Orgill::Products::WEB_SKU_COMMON_MAP
  source = Orgill::Products::LegSource.new(file: file, index_map: map)
  source.each { |p| ap(p) }
end

task default: [:legsource]
