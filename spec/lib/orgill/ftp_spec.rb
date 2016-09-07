require_relative '../../../lib/orgill/ftp'

RSpec.describe Orgill::FTP do
  context 'address assembley' do
    # Sanity tests
    it 'has the right base address' do
      expect(Orgill::FTP::Base_URL).to eq 'ftp.orgill.com'
    end

    it 'has base path' do
      expect(Orgill::FTP::Base_Path).to eq '/orgillftp/webfiles'
    end
  end
end

FTPImageHelper = Orgill::Products::FTPImageHelper

RSpec.describe FTPImageHelper do
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

    actual = FTPImageHelper.pick_latest_folder(folder_list)
    expect(actual).to eq 'Week32'
  end

  # TODO: add VCR integration_test for this.
end
