module S3MediaServerApi
  module Media
    class Video
      VIDEO = 'video'

      class << self

        def create(path)
          aws_file_response = Uploader.upload(path)
          aws_file_uuid = aws_file_response[:data][:uuid]
          MediaApi.create(aws_file_uuid, VIDEO)
        end

        def resolve(uuid)
          MediaApi.resolve(uuid, VIDEO)
        end

        def destroy(uuid)
          MediaApi.destroy(uuid, VIDEO)
        end
      end
    end
  end
end
