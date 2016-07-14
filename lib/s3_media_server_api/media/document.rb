module S3MediaServerApi
  module Media
    class Document< CommonMediaApi
      DOCUMENT = 'document'

      def url
        @params[:url if exist?
      end

      class << self

        def create(path)
          Document.new(super(path))
        end

        def resolve(uuid)
          Document.new(super(uuid))
        end

        private

          def media_type; DOCUMENT; end
      end
    end
  end
end
