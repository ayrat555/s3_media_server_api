require 'mimemagic'
require 'asynk'
require 'parallel'
require 'faraday'

module S3MediaServerApi
  module Uploader

    class << self

      class UploaderError < S3MediaServerApiError; end
      class PartUploadError < UploaderError; end

      def upload(file_path)
        parts = []
        response = AwsFile.create(file_path)
        default_part_size = response[:data][:default_part_size]
        aws_file_uuid = response[:data][:uuid]
        uploads_count = response[:data][:uploads_count]
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

        def close_all_parts(parts)
          parts.each do |part|
            part[:body].close
          end
        end

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

        def part_size(total_size, part_size, offset)
          if offset + part_size > total_size
            total_size - offset
          else
            part_size
          end
        end

        def upload_part(url, data)
          conn = Faraday.new(url: url) do |faraday|
            faraday.adapter :net_http
          end
          resp = conn.put do |req|
            req.body = data
            req.headers['Content-Type'] = ''
          end
          resp.success?
        end
    end
  end
end
