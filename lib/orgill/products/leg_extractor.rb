module Orgill
  module Products
    class LegSource
      attr_reader :products, :source

      def initialize(data: nil, file: nil)
        raise(ArgumentError) if file.nil? && data.nil? # if no arguments
        raise(ArgumentError) if !file.nil? && !data.nil? # if too many sources

        # converge source once it is to string level
        @source = data || File.read(file)
        @products = @source
      end
    end
  end
end

  # For detabbing method docs
  # Don't use single quoted input here. It will fail silently. I'm not too
  # worried about this, as input will usually be read from a file, rather
  # than input manually.
