module Orgill
  module Products
    WEB_SKU_COMMON_MAP = {
      0 => 'Orgill-SKU',                  # non-id?
      1 => 'Model-Number',
      2 => 'Nomenclature-Extended',
      3 => 'Width',                       # (Float)
      4 => 'Height',                      # (Float)
      5 => 'Length',                      # (Float)
      6 => 'Weight',                      # (Float)
      7 => 'Vendor-Number',
      8 => 'Catalog-Vendor-Name',
      9 => 'Nomenclature',
      10 => 'Catalog-Page-Number',
      11 => 'Suggested-Retail',
      12 => 'Selling-Unit',               # code for a unit (PK, BX, EA) maybe with whitespace, then with a #
      13 => 'BUYER',
      14 => 'Image',                      # jpg filenames
      15 => 'Pro-Benchmark-Retail',
      16 => 'UPC-CODE',
      17 => 'REG-PRICE',
      18 => 'VP1-PRICE',
      19 => 'VP2-PRICE',
      20 => 'ADV-PRICE',
      21 => 'RETAIL-SENSITIVITY',
      22 => 'BENCHMARK-RETAIL',           # (Float) Researched optimal retail price
      23 => 'QUANTITY-ROUND-OPTION',      # (Bool)
      24 => 'OLD-UPC',
      25 => 'PRO-SENSITIVITY',
      26 => 'VENDOR-UNIT-OF-MEASURE',
      27 => 'CLAIMS-CODE',
      28 => 'CLAIMS-MEMO-FLAG',
      29 => 'REPLACEMENT-ITEM',
      30 => 'SUBSTITUTE-ITEM',
      31 => 'COUNTRY-CODE',
      32 => 'HARMONIZED-CODE-1',
      33 => 'HARMONIZED-CODE-2',
      34 => 'HARMONIZED-CODE-3',
      35 => 'BUYING-DEPT-DESC',
      36 => 'HAZARDOUS-INLAND',           # (Bool)
      37 => 'HAZARDOUS-MARINE',           # (Bool)
      38 => 'KIT-ITEM-SWITCH',
      39 => 'KIT-ITEM-KEY',
      40 => 'CONTAINER-UPC',
      41 => 'RETAIL-UNIT-OF-MEASURE',
      42 => 'CUBIC-DIVISOR',
      43 => 'SHIPPABLE-BY-UPS-FEDEX-USPS' # (Bool)
    }.freeze
  end
end
