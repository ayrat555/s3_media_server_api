require 'mimemagic'
require 'asynk'
require 'parallel'
require 'faraday'

module S3MediaServerApi
  module Uploader

    class << self

      class UploaderError < S3MediaServerApiError; end
      class FileCreationError < UploaderError; end
      class PartUploadError < UploaderError; end
      class CompleteUploadError < UploaderError; end

      def upload(file_path, upload_threads_count = 4)
        parts = []
        mime_type = file_mime_type(file_path)

        response = Asynk::Publisher.sync_publish('s3_media_server.aws_file.create', action: :create,
          size: File.size(file_path), mime_type: mime_type)
        raise FileCreationError.new(response[:body]) unless response.success?

        default_part_size = response[:data][:default_part_size]
        aws_file_uuid = response[:data][:uuid]
        uploads_count = response[:data][:uploads_count]
        parts = compute_parts(file_path, default_part_size)
        Parallel.each(parts, in_threads: upload_threads_count) do |part|
          response = Asynk::Publisher.sync_publish('s3_media_server.uploads.show', action: :show, aws_file_uuid: aws_file_uuid, uuid: part[:part_number])
          upload_url = response[:data][:upload_url]
          raise PartUploadError.new(response[:body]) unless upload_part(upload_url, part[:body].read)
        end

        response = Asynk::Publisher.sync_publish('s3_media_server.aws_file.complete_upload', action: :complete_upload, uuid: aws_file_uuid)
        raise CompleteUploadError.new(response[:body]) unless response.success?
        response
      ensure
        close_all_parts(parts)
      end

      private

        def file_mime_type(file_source_path)
          mime_magic = MimeMagic.by_magic(File.open(file_source_path))
          mime_magic ? mime_magic.type : 'application/octet-stream'
        end

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
