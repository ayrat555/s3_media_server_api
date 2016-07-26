module S3MediaServerApi
  module Media
    class Document< CommonMediaApi
      DOCUMENT = 'document'

      def url
        @params[:url]
      end

      class << self

        private

          def media_type; DOCUMENT; end
      end
    end
  end
end
