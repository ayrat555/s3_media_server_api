module S3MediaServerApi
  module Media
    class CommonMediaApiError < S3MediaServerApiError; end
    class CreationError < CommonMediaApiError ; end

    class CommonMediaApi

      class << self

        def create(path)
          aws_file_response = Uploader.upload(path)
          aws_file_uuid = aws_file_response[:data][:uuid]
          params = (media_type == 'video') ? { uuid: aws_file_uuid } : { aws_file_uuid: aws_file_uuid }
          response = AsynkRequest.sync_request(base_path, :create, params)
          raise CreationError.new(response[:body]) unless response.success?
          response
        end

        def destroy(uuid)
          AsynkRequest.async_request(base_path, :destroy, uuid: uuid)
        end

        def resolve(uuid)
          AsynkRequest.sync_request(base_path, :resolve, uuid: uuid)
        end

        def custom_sync_request(action, params)
          AsynkRequest.sync_request(base_path, action, params)
        end

        def custom_async_request(action, params)
          AsynkRequest.async_request(base_path, action, params)
        end

        private

          def media_type; end

          def base_path; "media.#{media_type}"; end
      end
    end
  end
end
