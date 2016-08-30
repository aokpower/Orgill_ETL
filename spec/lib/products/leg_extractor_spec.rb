require_relative '../../../lib/orgill/products/leg_extractor'
require 'tempfile'

LegSource = Orgill::Products::LegSource # For brevity's sake

# split source and formatter classes?
# Any module -> class translation issues?
# Don't forget yard docs!

# helper method to take care of temporary file allocation/deletion
# use |file| file.write to insert content
def use_tmp_file(&block)
  file = Tempfile.new('orgill_etl_leg_source_tmp')
  yield file
  file.close
  file.unlink
end

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
            file.write 'foo'
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
          expect { LegSource.new(data: 'foo', file: 'foo.txt') }
            .to raise_error(ArgumentError)
        end
      end
    end

    context 'each' do
    end
  end

  # context 'de-tabularizing' do
  #   it 'transforms tabular string data to arrays of arrays' do
  #     pending
  #     data = "foo~   bar ~ baz ~\r\nboo~ ~biz"
  #     this = Orgill::Extractor.tabularize_string(data)
  #     expect(this).to eq [['foo', 'bar', 'baz'], ['boo', '', 'biz']]
  #   end
  # end
end
