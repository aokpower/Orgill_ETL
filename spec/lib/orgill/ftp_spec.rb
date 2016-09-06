require_relative '../../../lib/orgill/ftp'

RSpec.describe Orgill::FTP do
  context 'address assembley' do
    it 'has the right base address' do
      expect(Orgill::FTP::BaseURL).to eq 'ftp.orgill.com'
    end
  end
end
