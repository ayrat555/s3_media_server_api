module S3MediaServerApi
  module Mocked
    module Uploader
      class << self
        def upload(file_path)
          uuid = SecureRandom.uuid
          part_size = 5*1024*1024
          response = {data:   {uuid: uuid,
                               size: File.size(file_path),
                               mime_type: file_mime_type(file_path),
                               uploads_count: parts_count(file_path, part_size),
                               default_part_size: part_size,
                               state: "uploaded",
                               public_url: "https://storage-nginx.stage.govermedia.com/test-bucket/test_files/#{uuid}.mp3",
                               name: File.basename(file_path)}}
          AwsFile.new(response)
        end

        private

          def file_mime_type(file_source_path)
            mime_magic = MimeMagic.by_magic(File.open(file_source_path))
            mime_magic ? mime_magic.type : 'application/octet-stream'
          end

          def parts_count(source, default_part_size)
            size = File.size(source)
            offset, part_number = 0, 1
            while offset < size
              part_number += 1
              offset += default_part_size
            end
            part_number
          end
      end
    end
  end
end
