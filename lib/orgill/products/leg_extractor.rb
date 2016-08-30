module Orgill
  module Products
    class LegSource
      attr_reader :products, :source

      def self.parse(string, index_map: nil)
        detabularize(string).map do |row|
          unless index_map.nil?
            Hash[row.each_with_index.map { |val, ind| [index_map[ind], val] }]
          else
            row
          end
        end
      end

      def initialize(data: nil, file: nil, index_map: nil)
        raise(ArgumentError) if file.nil? && data.nil? # if no arguments
        raise(ArgumentError) if !file.nil? && !data.nil? # if too many sources

        # converge source once it is to string level
        @source   = data || File.read(file)
        @products = self.class.parse(@source, index_map: index_map)
      end

      def each
        @products.each { |p| yield(p) }
      end

      private

      def self.detabularize(string)
        string
          .split("\r\n") # split products
          .map { |row| row.split(/\s*~\s*/) } # split product fields
      end
    end
  end
end

  # For detabbing method docs
  # Don't use single quoted input here. It will fail silently. I'm not too
  # worried about this, as input will usually be read from a file, rather
  # than input manually.
