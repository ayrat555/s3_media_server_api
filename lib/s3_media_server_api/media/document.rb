module S3MediaServerApi
  module Media
    class Document
      DOCUMENT = 'document'

      class << self

        def create(path)
          aws_file_response = Uploader.upload(path)
          aws_file_uuid = aws_file_response[:data][:uuid]
          MediaApi.create(aws_file_uuid, DOCUMENT)
        end

        def resolve(uuid)
          MediaApi.resolve(uuid, DOCUMENT)
        end

        def destroy(uuid)
          MediaApi.destroy(uuid, DOCUMENT)
        end
      end
    end
  end
end
