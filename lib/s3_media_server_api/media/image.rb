module S3MediaServerApi
  module Media
    class Image< CommonMediaApi
      IMAGE = 'image'

      class ImageObject

        def initialize(params)
          @params = params.nil? ? {} : params
        end

        def url
          @params[:url]
        end

        def width
          @params[:width]
        end

        def height
          @params[:height]
        end

        def as_hash
          @params
        end
      end

      def source
        ImageObject.new(@params[:source])
      end

      def thumb
        ImageObject.new(@params[:thumb])
      end

      class << self
        #
        # copies image file
        # parameters: uuid - uuid of file
        #             aduio - url of image file
        # returns: response with copied image
        #
        def copy(uuid)
          return unless uuid
          Image.new(custom_sync_request(:copy, uuid: uuid))
        end
        #
        # sends request to make thumb of image
        # parameters: uuid - uuid of file
        #
        def resize(uuid)
          return unless uuid
          custom_async_request(:resize, uuid: uuid)
        end

        private

          def media_type; IMAGE; end
      end
    end
  end
end
