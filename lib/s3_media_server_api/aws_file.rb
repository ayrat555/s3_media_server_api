module S3MediaServerApi
  class AwsFile

    class << self
      class AwsFileError < S3MediaServerApiError; end
      class FileCreationError < AwsFileError; end
      class CompleteUploadError < AwsFileError; end

      def create(file_path)
        params = {
                   size: File.size(file_path),
                   mime_type: file_mime_type(file_path)
                 }
        response = AsynkRequest.sync_request(base_path, :create, params)
        raise FileCreationError.new(response[:body]) unless response.success?
        response
      end

      def show(uuid)

      end

      def get_signed_upload_url(aws_file_uuid, part_number)
        response = AsynkRequest.sync_request(:uploads, :show, aws_file_uuid: aws_file_uuid, uuid: part_number)
        response[:data][:upload_url]
      end

      def complete_upload(uuid)
        response = AsynkRequest.sync_request(base_path, :complete_upload, uuid: uuid)
        raise CompleteUploadError.new(response[:body]) unless response.success?
        response
      end

      private

        def file_mime_type(file_source_path)
          mime_magic = MimeMagic.by_magic(File.open(file_source_path))
          mime_magic ? mime_magic.type : 'application/octet-stream'
        end

        def base_path
          'aws_file'
        end
    end
  end
end
