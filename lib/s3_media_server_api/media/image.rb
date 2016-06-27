module S3MediaServerApi
  module Media
    class Image
      IMAGE = 'image'

      class << self

        def create(path)
          CommonMediaApi.create(path, IMAGE)
        end

        def resolve(uuid)
          CommonMediaApi.resolve(uuid, IMAGE)
        end

        def destroy(uuid)
          CommonMediaApi.destroy(uuid, IMAGE)
        end

        def copy(uuid)
          Asynk::Publisher.sync_publish('s3_media_server.media.image.copy', uuid: uuid)
        end

        def resize(uuid)
          Asynk::Publisher.publish('s3_media_server.media.image.resize', uuid: uuid)
        end
      end
    end
  end
end
