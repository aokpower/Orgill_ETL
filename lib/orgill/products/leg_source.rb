module Orgill
  module Products
    # Kiba source for the "Legacy" or LTS Orgill file format.
    class LegSource
      attr_reader :products, :source

      # @param string [String] data (in string form) to be parsed
      # @param index_map [Hash] Optional index map.
      #   An example can be seen in the 'can take an index map' spec
      # @return [Array] Array of Arrays, or Array of Hashes if index_map is used.
      #   Bottom elements of the Arrays or Hashes are Strings.
      # @note don't use literal strings here. '\r\n' isn't processed properly
      # @example
      #   Orgill::Products::LegSource.parse("foo~   bar ~ baz ~\r\nboo~ ~biz")
      #     #=> [['foo', 'bar', 'baz'], ['boo', '', 'biz']]
      # @see detabularize
      def self.parse(string, index_map: nil)
        detabularize(string).map do |row|
          unless index_map.nil?
            Hash[row.each_with_index.map { |val, ind| [index_map[ind], val] }]
          else
            row
          end
        end
      end

      # Sets #source, parses it into #products.
      # @param data [String] data to be parsed into products
      # @param file [File] file data to be parsed into products
      # @note You can't use both data and file
      def initialize(data: nil, file: nil, index_map: nil)
        raise(ArgumentError) if file.nil? && data.nil? # if no arguments
        raise(ArgumentError) if !file.nil? && !data.nil? # if too many sources

        @source   = data || File.read(file)
        @products = self.class.parse(@source, index_map: index_map)
      end

      # @note Required for usage as a kiba source
      def each
        @products.each { |p| yield(p) }
      end

      class << self

        private

        # @param row_separator [String] "\r\n" by default.
        #   Try changing this to "\n" if you are having problems
        def detabularize(string, row_separator = "\r\n")
          # Orgill uses a tilda ('~') delimited 'spreadsheet' sort of file.
          string
            .split(row_separator) # split products
            .map { |row| row.split(/\s*~\s*/) } # split product fields
        end
      end
    end
  end
end
