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

      def add_item(uuid, kind:, media_file_uuid:)
        kind = kind.to_s
        return unless uuid || media_file_uuid || kind
        return unless ['videos', 'documents', 'images', 'audios'].include? kind

        params =  media_type.to_s == 'videos' ? {uuid: media_file_uuid} : {aws_file_uuid: media_file_uuid}
        params.merge!({kind: kind, collection_uuid: uuid})

        response = custom_sync_request(:add_item, params)

        case kind
        when 'videos'
          Video.new(response)
        when 'images'
          Image.new(response)
        when 'audios'
          Audio.new(response)
        when 'documents'
          Docuemnt.new(response)
        end
      end

        private

          def media_type; COLLECTION; end
      end
    end
  end
end
