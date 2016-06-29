module S3MediaServerApi
  class AwsFile

    class << self
      class AwsFileError < S3MediaServerApiError; end
      class FileCreationError < AwsFileError; end
      class CompleteUploadError < AwsFileError; end
      #
      # creates file on s3_media_server
      # parameters: file_path - path on file system to file
      #
      # returns: response with created file
      #
      def create(file_path)
        params = {
                   size: File.size(file_path),
                   mime_type: file_mime_type(file_path)
                 }
        response = AsynkRequest.sync_request(base_path, :create, params)
        raise FileCreationError.new(response[:body]) unless response.success?
        response
      end
      #
      # fetches media file
      # parameters: uuid - uuid of file
      #
      # returns: response with file information
      #
      def reolve(uuid)
        AsynkRequest.sync_request(base_path, :resolve, uuid: uuid)
      end
      #
      # fetches signed upload url to upload specified part number
      # parameters: uuid - file uuid
      #             part_numer - part number that will be uploaded
      #
      # returns:  signed upload url
      #
      def get_signed_upload_url(uuid, part_number)
        response = AsynkRequest.sync_request(:uploads, :show, aws_file_uuid: uuid, uuid: part_number)
        response[:data][:upload_url]
      end
      #
      # completes multipart upload
      # parameters: uuid - file uuid
      #
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
