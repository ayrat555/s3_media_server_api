module S3MediaServerApi
  module Services
    class UploaderExistenceService
      class << self

        def check(aws_file_uuid)
          return unless aws_file_uuid

          S3MediaServerApi::SimpleUploadersRepository.uploader_classes.each do |uploader_class|
            uploader = uploader_class.find_uploader_by_uuid(aws_file_uuid)
            S3MediaServerApi::AwsFile.file_exists(aws_file_uuid) and return if uploader.present?
          end
        end

      end
    end
  end
end