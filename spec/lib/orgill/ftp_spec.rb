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
    expect(@ftp.ftp.pwd).to eq '/'
  end

  context '#cd_images' do
    it 'changes folder to current image folder' do
    end
  end
end
