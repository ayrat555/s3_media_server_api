module S3MediaServerApi
  module Media
    class Image< CommonMediaApi
      IMAGE = 'image'

      class << self
        #
        # copies image file
        # parameters: uuid - uuid of file
        #             aduio - url of image file
        # returns: response with copied image
        #
        def copy(uuid)
          custom_sync_request(:copy, uuid: uuid)
        end
        #
        # sends request to make thumb of image
        # parameters: uuid - uuid of file
        #
        def resize(uuid)
          custom_async_request(:resize, uuid: uuid)
        end

        private

          def media_type; IMAGE; end
      end
    end
  end
end
