module S3MediaServerApi
  module Media
    class COLLECTION < CommonMediaApi
      COLLECTION = 'collection'

      def videos
        @params[:videos].map { |video| Video.new(video) } if @params[:videos]
      end

      def images
        @params[:images].map { |image| Image::ImageObject.new(image) } if @params[:images]
      end

      def documents
        @params[:documents].map { |documents| Video.new(document) } if @params[:documents]
      end

      def audios
        @params[:audios].map { |audios| Audio.new(audio) } if @params[:audios]
      end

      def owner_uuid
        @params[:owner_uuid]
      end

      class << self

        def resolve(uuid)
          Collection.new(super(uuid))
        end

        private

          def media_type; COLLECTION; end
      end
    end
  end
end
