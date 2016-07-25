module S3MediaServerApi
  module Consumers
    class S3MediaServerConsumer
      include Asynk::Consumer
      include ConsumerHelper

      set_consume 'broadcast.server.s3_media_server.aws_file.garbage_collect'

      set_queue_options ack: true
      set_subscribe_arguments manual_ack: true
      set_concurrency 1
      set_route_ending_as_action true
      rescue_from Exception, with: :handle_exception


      def garbage_collect(params)
        S3MediaServerApi::Services::UploaderExistenceService.check(params[:uuid])
      ensure
        ack!
      end
    end
  end
end
