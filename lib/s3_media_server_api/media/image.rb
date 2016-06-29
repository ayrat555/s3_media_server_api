module S3MediaServerApi
  module Media
    class Image< CommonMediaApi
      IMAGE = 'image'

      class << self

        def media_type; IMAGE; end

        def copy(uuid)
          custom_sync_request(:copy, uuid: uuid)
        end

        def resize(uuid)
          custom_async_request(:resize, uuid: uuid)
        end
      end
    end
  end
end
