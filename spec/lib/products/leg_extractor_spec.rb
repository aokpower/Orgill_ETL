require_relative '../../../lib/orgill/products/leg_extractor'
require 'tempfile'

LegSource = Orgill::Products::LegSource # For brevity's sake

# split source and formatter classes?
# Any module -> class translation issues?
# Don't forget yard docs!

# helper method to take care of temporary file allocation/writes/deletion
def use_tmp_file(content = 'foo', &block)
  file = Tempfile.new('orgill_etl_leg_source_tmp')
  file.write(content)
  file.close
  yield file
  file.unlink
end

short_data = "foo~   bar ~ baz ~\r\nboo~ ~biz"

RSpec.describe LegSource do
  context 'kiba source api methods' do
    context 'initialize' do
      context 'accepts' do
        # basically input tests
        it 'data only' do
          # I don't want to worry about file reading logic when I'm
          # just trying to test internal plumbing.
          actual = LegSource.new(data: 'foo').products
          # TODO: replace with something better than a nil check! after other tests are hammered out.
          expect(actual).to_not be_nil
        end

        it 'file only' do
          # verbose name for debugging purposes
          use_tmp_file do |file|
            actual = LegSource.new(file: file.path).products
            expect(actual).to_not be_nil
          end
        end
      end

      context 'errors when' do
        it 'no data or file' do
          expect { LegSource.new }.to raise_error(ArgumentError)
        end

        it 'both data and file' do
          use_tmp_file do |file|
            expect { LegSource.new(data: 'foo', file: file.path) }
              .to raise_error(ArgumentError)
          end
        end
      end

      context 'file:' do
        it 'reads file into @source as a string' do
          content = 'foo'
          use_tmp_file(content) do |file|
            actual = LegSource.new(file: file).source
            expect(actual).to eq content
          end
        end
      end

      context 'parsing' do
        it 'detabularizes with no map' do
          actual   = LegSource.parse(short_data)
          expected = [['foo', 'bar', 'baz'], ['boo', '', 'biz']]
          expect(actual).to eq expected
        end

        it 'can take an index map' do
          test_map = { 0 => 'one', 1 => 'two', 2 => 'three' }
          expected = [
            { 'one' => 'foo', 'two' => 'bar', 'three' => 'baz'},
            { 'one' => 'boo', 'two' => '', 'three' => 'biz'}
          ]
          actual = LegSource.parse(short_data, index_map: test_map)
          expect(actual).to eq expected
        end
      end
    end

    context 'each' do
    end
  end

end
