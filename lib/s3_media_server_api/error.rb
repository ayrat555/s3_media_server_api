module S3MediaServerApi
  class S3MediaServerApiError < RuntimeError
    class<<self
      def message_from_asynk_response(asynk_response)
        self.new("body: #{asynk_response.body}, message: #{asynk_response.error_message}")
      end
    end
  end
end
