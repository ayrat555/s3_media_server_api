module S3MediaServerApi
  module Media
    class Video< CommonMediaApi
      VIDEO = 'video'

      class << self

        def media_type; VIDEO; end

      end
    end
  end
end
