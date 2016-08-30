module Orgill
  module Products
    class LegSource
      attr_reader :products

      def initialize(data: nil, file: nil)
        # fail if no arguments
        fail(ArgumentError) if file.nil? && data.nil?
        # fail if too many sources
        fail(ArgumentError) if !file.nil? && !data.nil?

        @products = data || file
      end
    end
  end
end

  # For detabbing method docs
  # Don't use single quoted input here. It will fail silently. I'm not too
  # worried about this, as input will usually be read from a file, rather
  # than input manually.
