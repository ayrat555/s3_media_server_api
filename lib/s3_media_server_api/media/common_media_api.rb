module S3MediaServerApi
  module Media
    class CommonMediaApiError < S3MediaServerApiError; end
    class CreationError < CommonMediaApiError ; end

    class CommonMediaApi

      class << self

        def create(path, type)
          aws_file_response = Uploader.upload(path)
          aws_file_uuid = aws_file_response[:data][:uuid]
          params = (type == 'video') ? { uuid: aws_file_uuid } : { aws_file_uuid: aws_file_uuid }
          response = Asynk::Publisher.sync_publish("s3_media_server.media.#{type}.create", params)
          raise CreationError.new(response[:body]) unless response.success?
          response
        end

        def destroy(uuid, type)
          Asynk::Publisher.publish("s3_media_server.media.#{type}.destroy", uuid: uuid)
        end

        def resolve(uuid, type)
          Asynk::Publisher.sync_publish("s3_media_server.media.#{type}.resolve", uuid: uuid)
        end
      end
    end
  end
end
