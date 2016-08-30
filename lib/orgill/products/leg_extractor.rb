module Orgill
  module Products
    class LegSource
      attr_reader :products

      def initialize(input_data: nil, input_file: nil)
        # fail if no arguments
        fail(ArgumentError) if input_file.nil? && input_data.nil?
        # fail if too many sources
        fail(ArgumentError) if !input_file.nil? && !input_data.nil?

        @products = input_data || input_file
      end
    end
  end
end

  # For detabbing method docs
  # Don't use single quoted input here. It will fail silently. I'm not too
  # worried about this, as input will usually be read from a file, rather
  # than input manually.
