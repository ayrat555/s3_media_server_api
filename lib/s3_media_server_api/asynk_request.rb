module S3MediaServerApi
  module AsynkRequest
    class << self
      #
      # sends asynchronous request using Asynk gem - https://github.com/konalegi/asynk
      # parameters: path - base path of consumer
      #             action - consumer action
      #             params - parametes that will be passed to consumer
      #
      def async_request(path, action, params)
        Asynk::Publisher.publish("#{server}.#{path}.#{action}", params)
      end
      #
      # sends synchronous request using Asynk gem - https://github.com/konalegi/asynk
      # parameters: path - base path of consumer
      #             action - consumer action
      #             params - parametes that will be passed to consumer
      #
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
