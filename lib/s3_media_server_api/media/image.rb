module S3MediaServerApi
  module Media
    class Image
      IMAGE = 'image'

      class << self

        def create(path)
          aws_file_response = Uploader.upload(path)
          aws_file_uuid = aws_file_response[:data][:uuid]
          MediaApi.create(aws_file_uuid, IMAGE)
        end

        def resolve(uuid)
          MediaApi.resolve(uuid, IMAGE)
        end

        def destroy(uuid)
          MediaApi.destroy(uuid, IMAGE)
        end
      end
    end
  end
end
