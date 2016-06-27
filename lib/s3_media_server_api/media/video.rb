module S3MediaServerApi
  module Media
    class Video
      VIDEO = 'video'

      class << self

        def create(path)
          CommonMediaApi.create(path, VIDEO)
        end

        def resolve(uuid)
          CommonMediaApi.resolve(uuid, VIDEO)
        end

        def destroy(uuid)
          CommonMediaApi.destroy(uuid, VIDEO)
        end
      end
    end
  end
end
