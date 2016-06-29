require 'yaml'

module S3MediaServerApi
  class ConfigError < S3MediaServerApiError; end
  #
  # By default 4 threads is used for file uploading. To change
  # this value you can create config/s3_media_server_api.yml and specify
  # upload_thread_count
  #
  # Example
  #   prosuction:
  #     upload_thread_count: 10
  #
  class Config
    attr_reader :upload_thread_count

    def initialize
      @upload_thread_count = nil
      environment = ENV['RUBY_ENV'] || ENV['RAILS_ENV']
      if File.exists?('config/s3_media_server_api.yml')
        @attributes = YAML.load_file('config/s3_media_server_api.yml')[environment][:upload_thread_count]
      end
      @upload_thread_count ||= 4
    end
  end
end
