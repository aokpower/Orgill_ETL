require 'dotenv'
Dotenv.load

module Orgill
  # Use Orgilll's FTP server.
  class FTP
    # extend Orgill::Products::FTPImageHelper # why unintialized constant error?

    Base_URL  = 'ftp.orgill.com'.freeze
    Base_Path = '/orgillftp/webfiles'.freeze

    def initialize
      @credentials = {
        username: ENV['ORGILL_FTP_USERNAME'],
        password: ENV['ORGILL_FTP_PASSWORD']
      }
    end
  end
end

module Orgill
  module Products
    # Helper class for Orgill::FTP
    # @see Orgill::FTP
    class FTPImageHelper
      class << self
        # @param folder_list [Array[String]]
        # @return [String] name of most recent folder
        # @note this is for use with the web images folder
        def pick_latest_folder(folder_list)
          folder_list.select { |f_name| f_name[/week\d+/i] }
          .sort_by { |f_name| /week(\d+)/i.match(f_name).captures[0] }
          .last # because it sorts lowest -> highest
        end
      end
    end
  end
end
