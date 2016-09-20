require 'net/ftp'
require 'forwardable'
require 'dotenv'

Dotenv.load

module Orgill
  # Location and navigation info about Orgill's FTP folders.
  module FTPAddresses

    Base_URL     = 'ftp.orgill.com'.freeze
    Base_Path    = '/orgillftp/webfiles'.freeze
    Image_Folder = (Base_Path + '/WebImages').freeze

    # Picks the element matching the format /week(d+)/ where the week number
    # is highest.
    # @param folder_list [Array[String]] list of folder and/or file names.
    # @return [String] name of most recent folder
    # @note This is for use in the Image_Folder
    # @see Image_Folder
    def self.pick_latest_folder(folder_list)
      folder_list.select { |f_name| f_name[/week\d+/i] }
      .sort_by { |f_name| /week(\d+)/i.match(f_name).captures[0] }
      .last # because it sorts lowest -> highest
    end
  end
end

module Orgill
  # Use Orgill's FTP server.
  class FTP
    # Should this inherit from Net::FTP?
    extend Forwardable
    include Orgill::FTPAddresses

    def_delegators :ftp, :pwd, :close, :ls

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

    # Wrapper method for Net::FTP.ls. Parses 'ls -l' style file listings into
    # just file names.
    # @note this may not work with filenames using escaped whitespace.
    # @return [Array[String]] list of file names
    def ls
      ftp.ls.map { |f| f.split(/\s+/).last } # folder names need parsing
    end

    # Changes current directory to the latest image folder.
    # @return [self]
    # @see Orgill::FTPAddresses.pick_latest_folder
    def chdir_image_folder
      ftp.chdir(Image_Folder)
      image_folder = Orgill::FTPAddresses.pick_latest_folder(ls)
      ftp.chdir(image_folder)
      self
    end
  end
end
