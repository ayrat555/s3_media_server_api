require 'mimemagic'
require 'asynk'
require 'parallel'
require 'faraday'

module S3MediaServerApi

  # Module with file uplod finctionality implementation

  module Uploader

    class << self

      class UploaderError < S3MediaServerApiError; end
      class PartUploadError < UploaderError; end
      #
      # uploads file to amazon s3 and create AwsFile object
      # parameter : filepath - file path in file system
      # returns: [AwsFile object]
      #
      # Example
      #
      # file = S3MediaServerApi::Uploader.upload(/home/vasya/my_awesome_file.awesome)
      #
      def upload(file_path)
        parts = []
        file = AwsFile.create_from_path(file_path)
        default_part_size = file.default_part_size
        aws_file_uuid = file.uuid
        uploads_count = file.uploads_count
        parts = compute_parts(file_path, default_part_size)
        Parallel.each(parts, in_threads: S3MediaServerApi.upload_thread_count) do |part|
          signed_upload_url = AwsFile.get_signed_upload_url(aws_file_uuid, part[:part_number])
          raise PartUploadError.new(response[:body]) unless upload_part(signed_upload_url, part[:body].read)
        end

        AwsFile.complete_upload(aws_file_uuid)
      ensure
        close_all_parts(parts)
      end

      private
        #
        # closes all parts of file that were used in multipart upload to prevent memory leak
        #
        def close_all_parts(parts)
          parts.each do |part|
            part[:body].close
          end
        end
        #
        # divides file into parts for multipart upload
        # parameter:
        #            source            - path of source file
        #            default_part_size -  wanted part size (in bytes)
        # returns:   [ array of parts ]
        #
        def compute_parts(source, default_part_size)
          size = File.size(source)
          offset, part_number, parts = 0, 1, []
          while offset < size
            parts << {
              part_number: part_number,
              body: FilePart.new(source: source, offset: offset, size: part_size(size, default_part_size, offset))
            }

            part_number += 1
            offset += default_part_size
          end
          parts
        end
        #
        # calculates size of one part - last part often has smaller size than other parts
        # parameters: total_size - totol size of file (in bytes)
        #             part_size  - default size of one part (in bytes)
        #             offset     - offset from beginning of file (in bytes)
        # returns: part size
        #
        def part_size(total_size, part_size, offset)
          if offset + part_size > total_size
            total_size - offset
          else
            part_size
          end
        end
        #
        # uploads data to specified url
        # parameters: url - upload url
        #             data  - data to upload
        # returns: true if upload was successful
        #          false otherwise
        #
        def upload_part(url, data)
          conn = Faraday.new(url: url) do |faraday|
            faraday.adapter :net_http
          end
          resp = conn.put do |req|
            req.body = data
            # to prevent Faraday from adding garbage header
            req.headers['Content-Type'] = ''
          end
          resp.success?
        end
    end
  end
end
