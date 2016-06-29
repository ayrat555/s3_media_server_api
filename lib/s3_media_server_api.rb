require "s3_media_server_api/version"
require "s3_media_server_api/error"
require "s3_media_server_api/config"
require "s3_media_server_api/uploader"
require "s3_media_server_api/file_part"
require "s3_media_server_api/aws_file"
require "s3_media_server_api/media"
require "s3_media_server_api/asynk_request"

module S3MediaServerApi

  class << self

    def upload_thread_count
      config.upload_thread_count
    end

    private

      def config
        @@config ||= Config.new
      end
  end
end
