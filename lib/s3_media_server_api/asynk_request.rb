module S3MediaServerApi
  module AsynkRequest
    class << self
      def async_request(path, action, params)
        Asynk::Publisher.publish("#{server}.#{path}.#{action}", params)
      end

      def sync_request(path, action, params)
        Asynk::Publisher.sync_publish("#{server}.#{path}.#{action}", params)
      end

      private

        def server
          's3_media_server'
        end
    end
  end
end
