module S3MediaServerApi
  module Media
    class Video< CommonMediaApi
      VIDEO = 'video'

      class Version
        def initialize(params)
          @params = params
        end

        def url
          @params[:url]
        end

        def format
          @params[:format]
        end

        def resolution
          @params[:resolution]
        end

        def size
          @params[:size]
        end
      end

      def preview
        @params[:preview]
      end

      def duration
        @params[:duration]
      end

      def transcoded
        @params[:transcoded]
      end

      def embed_url
        @params[:embed_url]
      end

      def provider
        @params[:provider]
      end

      def screenshots
        @params[:screenshots].map { |screenshot| Image::ImageObject.new(screenshot) }
      end

      def versions
        @params[:versions].map { |version| Version.new(version) }
      end

      class << self

        def create(path)
          Video.new(super(path))
        end

        def resolve(uuid)
          Video.new(super(uuid))
        end

        private

          def media_type; VIDEO; end
      end
    end
  end
end
