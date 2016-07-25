module S3MediaServerApi
  class SimpleUploadersRepository
    class << self
      def uploader_classes
        @uploader_classes ||= SimpleFileUploader::BaseUploader.descendants
      end
    end
  end

end
