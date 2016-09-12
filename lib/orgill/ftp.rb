require 'dotenv'
require 'net/ftp'
Dotenv.load

module Orgill
  module FTPAddresses

    Base_URL  = 'ftp.orgill.com'.freeze
    Base_Path = '/orgillftp/webfiles'.freeze

    # @param folder_list [Array[String]]
    # @return [String] name of most recent folder
    # @note this is for use with the web images folder
    def self.pick_latest_folder(folder_list)
      folder_list.select { |f_name| f_name[/week\d+/i] }
      .sort_by { |f_name| /week(\d+)/i.match(f_name).captures[0] }
      .last # because it sorts lowest -> highest
    end
  end
end

module Orgill
  # Use Orgilll's FTP server.
  class FTP
    include Orgill::FTPAddresses

    attr_reader :ftp

    def initialize
      @login = {
        username: ENV['ORGILL_FTP_USERNAME'],
        password: ENV['ORGILL_FTP_PASSWORD']
      }
      @ftp = Net::FTP.new(Base_URL).tap do |ftp|
        ftp.login(@login[:username], @login[:password])
      end
    end
  end
end
