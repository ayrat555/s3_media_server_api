module S3MediaServerApi
  module Media
    class Document< CommonMediaApi
      DOCUMENT = 'document'

      class << self

        def media_type; DOCUMENT; end

      end
    end
  end
end
