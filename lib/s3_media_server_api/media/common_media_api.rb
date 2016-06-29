module S3MediaServerApi
  module Media
    class CommonMediaApiError < S3MediaServerApiError; end
    class CreationError < CommonMediaApiError ; end
    #
    # Parent module for all media api, implements common methods for all media files
    # To use methods from this module new module must be inherited from this module and
    # media_type method with existing media type must be overwritten
    #
    class CommonMediaApi

      class << self
        #
        # creates media file
        # parameters: path - file path in file system
        #
        # returns: response with created AwsFile information
        #
        def create(path)
          aws_file_response = Uploader.upload(path)
          aws_file_uuid = aws_file_response[:data][:uuid]
          params = (media_type == 'video') ? { uuid: aws_file_uuid } : { aws_file_uuid: aws_file_uuid }
          response = AsynkRequest.sync_request(base_path, :create, params)
          raise CreationError.new(response[:body]) unless response.success?
          response
        end
        #
        # destroys media file
        # parameters: uuid - uuid of file
        #
        def destroy(uuid)
          AsynkRequest.async_request(base_path, :destroy, uuid: uuid)
        end
        #
        # fetches media file
        # parameters: uuid - uuid of file
        #
        # returns: response with file information
        #
        def resolve(uuid)
          AsynkRequest.sync_request(base_path, :resolve, uuid: uuid)
        end
        #
        # this method should be used to send custom synchronous request to
        # s3_media_server. For example, to copy image file
        # parameters: action - method that should be called
        #             params - parameters for specified method
        # Example:
        #          custom_sync_request (:copy, 'image')
        #
        def custom_sync_request(action, params)
          AsynkRequest.sync_request(base_path, action, params)
        end
        #
        # this method should be used to send custom asynchronous request to
        # s3_media_server. For example, to cut audio file
        # parameters: action - method that should be called
        #             params - parameters for specified method
        # Example:
        #          custom_async_request (:cut, 'image')
        #
        def custom_async_request(action, params)
          AsynkRequest.async_request(base_path, action, params)
        end

        private
          #
          # specifies media type which methods will be called
          #
          def media_type; end
          #
          # base path of media consumers on s3_media_server
          #
          def base_path; "media.#{media_type}"; end
      end
    end
  end
end
