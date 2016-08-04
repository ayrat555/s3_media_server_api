require 'fileutils'
require 'curb'

module S3MediaServerApi
  module Downloader

    class << self
      def download_by_url(url)
        file_path = generate_random_file_name
        easy = Curl::Easy.new(url)
        easy.ssl_verify_peer = false
        File.open(file_path, 'wb') do |f|
          easy.on_body {|data| f << data; data.size }
          easy.perform
        end
        file_path
      end

      def remove_if_exists(path)
        return if path.nil?
        FileUtils.rm(path) if File.exist?(path)
      end

      private

        def generate_random_file_name
          File.join(tmp_dir, SecureRandom.uuid)
        end

        def tmp_dir
          path = File.join('tmp', 'files')
          create_dir_if_not_exists(path)
          path
        end

        def create_dir_if_not_exists(path)
          FileUtils.mkdir_p path
        end

      end
  end
end
