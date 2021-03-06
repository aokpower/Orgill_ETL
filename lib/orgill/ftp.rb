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
  class FTPProtoError < StandardError; end
  class FTPFileNotFoundError < FTPProtoError; end
  class FTPInvalidFilenameError < FTPProtoError; end

  # Use Orgill's FTP server.
  class FTP
    # Should this inherit from Net::FTP?
    include Orgill::FTPAddresses

    extend Forwardable
    def_delegators :ftp, :pwd, :close

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
      # TODO: Add test for filename with escaped whitespace
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

    # Get an image file. Goes to image folder and downloads specified file.
    # @param image_name [String] Image file name. ex: '0130104.jpg'
    # @param output_filename [String] Optional output name. Nil by default.
    # @note An empty file is written locally even when file isn't found.
    def get_image(image_name, output_filename=nil)
      raise FTPInvalidFilenameError unless is_valid_filename?(image_name)
      chdir_image_folder
      begin
        ftp.getbinaryfile(*[image_name, output_filename].compact)
      rescue Net::FTPPermError
        raise FTPFileNotFoundError, "#{image_name} was not found"
      end
    end

    private

    def is_valid_filename?(filename)
      # WARN: Regex is for invalid ntfs filenames, but should work ok here.
      !filename.match(/[\x00\/\\:\*\?\"<>\|]/)
    end
  end
end
