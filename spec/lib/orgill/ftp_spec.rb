require_relative '../../../lib/orgill/ftp'

RSpec.describe Orgill::FTP do
end

FTPAddresses = Orgill::FTPAddresses

RSpec.describe FTPAddresses do
  context 'address assembley' do
    # Sanity tests
    it 'has the right base address' do
      expect(FTPAddresses::Base_URL).to eq 'ftp.orgill.com'
    end

    it 'has base path' do
      expect(FTPAddresses::Base_Path).to eq '/orgillftp/webfiles'
    end

    context '#pick_latest_folder' do
      it 'can pick most recent image folder from list' do
        # orgill has images organized like so:
        # images/week29/*.JPG
        # this the "week*" folder is changed periodically, so We will need to
        # request directory contents and match the latest folder, either through
        # a regex, or through folder modification dates.

        folder_list = %w(
          Foox.xzf
          Week28
          Week29
          Week32
          Week30
          Week31
        )

        actual = FTPAddresses.pick_latest_folder(folder_list)
        expect(actual).to eq 'Week32'
      end

      it 'returns nil if no appropriate folder' do
        folder_list = ['Foo.xzf']

        actual = FTPAddresses.pick_latest_folder(folder_list)
        expect(actual).to be_nil
        actual_empty = FTPAddresses.pick_latest_folder([])
        expect(actual_empty).to be_nil
      end
    end
  end
end


RSpec.describe Orgill::FTP do
  # Can't use VCR to mock ftp requests :( ...
  # yet. https://github.com/vcr/vcr/issues/589

  before(:each) do
    @ftp = Orgill::FTP.new
  end

  after(:each) do
    @ftp.close
  end

  it 'can pwd (sanity test)' do
    expect(@ftp.pwd).to eq '/'
  end

  context '#chdir_images' do
    it 'changes folder to current image folder' do
      contains_png = @ftp.chdir_image_folder.ls.any? { |f| f.include?('.jpg') }
      expect(contains_png).to_not be_nil
    end
  end

  context '#get_image' do
    # This shouldn't need the user to call #chdir_images first
    context 'fails when:' do
      it 'filename doesn\'t exist' do
        expect { @ftp.get_image('doesnt_exist.txt') }
          .to raise_error(Orgill::FTPFileNotFoundError)
      end

      it 'given an invalid filename' do
        expect { @ftp.get_image("|<.txt") }
          .to raise_error(Orgill::FTPInvalidFilenameError)
      end
      
      # it 'output file already exists' # not sure how to test this
    end

    context 'when successful' do
      it 'successfully grabs and writes good files' do
        # ?: Remove foobie_belch.jpg if it exists
        output_filename = 'foobie_belch.jpg'
        @ftp.get_image('4138392.jpg', output_filename)
        expect(File.exist?(output_filename)).to eq true
        `rm #{output_filename}` # DELETE CREATED FILE
      end

      it 'defaults to basename when output filename not given' do
        remote_file = '4138392.jpg'
        expected_output_name = File.basename(remote_file)
        @ftp.get_image(remote_file)
        expect(File.exist?(expected_output_name)).to eq true
        `rm #{expected_output_name}` # DELETE CREATED FILE
      end
    end
  end
end
