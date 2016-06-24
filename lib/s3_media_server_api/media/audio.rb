module S3MediaServerApi
  module Media
    class Audio
      AUDIO = 'audio'

      class << self

        def create(path)
          aws_file_response = Uploader.upload(path)
          aws_file_uuid = aws_file_response[:data][:uuid]
          MediaApi.create(aws_file_uuid, AUDIO)
        end

        def resolve(uuid)
          MediaApi.resolve(uuid, AUDIO)
        end

        def destroy(uuid)
          MediaApi.destroy(uuid, AUDIO)
        end
      end
    end
  end
end
