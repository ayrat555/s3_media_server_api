module S3MediaServerApi
  module Media
    class Document
      DOCUMENT = 'document'

      class << self

        def create(path)
          CommonMediaApi.create(path, DOCUMENT)
        end

        def resolve(uuid)
          CommonMediaApi.resolve(uuid, DOCUMENT)
        end

        def destroy(uuid)
          CommonMediaApi.destroy(uuid, DOCUMENT)
        end
      end
    end
  end
end
