module S3MediaServerApi
  module Media
    class Collection < CommonMediaApi
      COLLECTION = 'collection'

      def videos
        @params[:videos].map { |video| Video.new(data: video) } if @params[:videos]
      end

      def images
        @params[:images].map { |image| Image::ImageObject.new(data: image) } if @params[:images]
      end

      def documents
        @params[:documents].map { |document| Video.new(data: document) } if @params[:documents]
      end

      def audios
        @params[:audios].map { |audio| Audio.new(data: audio) } if @params[:audios]
      end

      def owner_uuid
        @params[:owner_uuid]
      end

      class << self

        private

          def media_type; COLLECTION; end
      end
    end
  end
end
