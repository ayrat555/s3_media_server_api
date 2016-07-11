module S3MediaServerApi
  class AwsFile

    def initialize(response)
      @params = response[:data]
    end

    def uuid
      @params[:uuid]
    end

    def size
      @params[:size]
    end

    def mime_type
      @params[:mime_type]
    end

    def uploads_count
      @params[:uploads_count]
    end

    def default_part_size
      @params[:default_part_size]
    end

    def state
      @params[:state]
    end

    def public_url
      @params[:public_url]
    end

    def name
      @params[:name]
    end

    def as_hash
      @params
    end

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
      def create_from_path(file_path)
        params = {
                   size: File.size(file_path),
                   mime_type: file_mime_type(file_path),
                   name: File.basename(file_path)
                 }
        response = AsynkRequest.sync_request(base_path, :create, params)
        raise FileCreationError.message_from_asynk_response(response) unless response.success?
        AwsFile.new(response)
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
        raise CompleteUploadError.message_from_asynk_response(response) unless response.success?
        AwsFile.new(response)
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
