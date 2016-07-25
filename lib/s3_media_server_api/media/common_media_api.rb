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

      def initialize(response)
        @params = response[:data].nil? ? {} : response[:data]
      end

      def uuid
        @params[:uuid]
      end

      def name
        @params[:name]
      end

      def size
        @params[:size]
      end

      def as_hash
        @params
      end

      def exist?
        !@params.empty?
      end

      class << self
        #
        # creates media file
        # parameters: path - file path in file system
        #
        # returns: response with created AwsFile information
        #
        def create(path)
          aws_file = S3MediaServerApi::Config.mocked ? Mocked::Uploader.upload(path) : Uploader.upload(path)
          uuid = aws_file.uuid
          params = (media_type == 'video') ? { uuid: uuid } : { aws_file_uuid: uuid }
          response = AsynkRequest.sync_request(base_path, :create, params)
          raise CreationError.message_from_asynk_response(response) unless response.success?
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
          cache_key = "#{media_type}/#{uuid}"
          Config.cache_class.fetch(cache_key) do
            AsynkRequest.sync_request(base_path, :resolve, uuid: uuid)
          end
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
