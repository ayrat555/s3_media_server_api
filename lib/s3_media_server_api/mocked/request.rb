module S3MediaServerApi
  module Mocked
    class Request

      def initialize(hash)
        @body = hash
      end

      def success?
        true
      end

      def [](key)
        @body[key]
      end

      class << self
        def sync_publish(path, params)
          case path
          when /s3_media_server.media.(audio).(\.*)/
            mocked_audio_sync_request(params)
          when /s3_media_server.media.(video).(\.*)/
            mocked_video_sync_request(params)
          when /s3_media_server.media.(image).(\.*)/
            mocked_image_sync_request(params)
          when /s3_media_server.media.(document).(\.*)/
            mocked_document_sync_request(params)
          end
        end

        def publish(path, params)
          true
        end

        private


          def mocked_audio_sync_request(params)
            uuid = params[:aws_file_uuid] ? params[:aws_file_uuid] : params[:uuid]
            response = {data: { url: "https://storage-nginx.stage.govermedia.com/test-bucket/test_files/#{SecureRandom.uuid}.mp3",
                                sample_url: "https://storage-nginx.stage.govermedia.com/test-bucket/test_files/#{SecureRandom.uuid}.mp3",
                                uuid: uuid,
                                size: 704512,
                                sample_uploaded: true,
                                name: "music_test.mp3",
                                duration: 87.891875,
                                sample_duration: 19.983673}}
            Request.new(response)
          end

          def mocked_video_sync_request(params)
            response = {:data=>{:duration=>6.037,
                                :transcoded=>true,
                                :uuid=>params[:uuid],
                                :versions=>[{ :url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/18e776ab-c4ca-40cd-9ecb-a605664ce118.mp4",
                                              :format=>"mp4",
                                              :size=>326089,
                                              :resolution=>"r240p"},
                                            { :url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/c5c9bf51-76c7-42e3-b2ce-4d55d41df815.mp4",
                                              :format=>"mp4",
                                              :size=>602906,
                                              :resolution=>"r360p"},
                                            { :url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/475a37b9-50de-472f-a7f4-949774fb46b4.mp4",
                                              :format=>"mp4",
                                              :size=>3188011,
                                              :resolution=>"source"},
                                            { :url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/5db270ce-966a-4caa-a4ca-c2dd57ad3b8b.webm",
                                              :format=>"webm",
                                              :size=>382660,
                                              :resolution=>"r240p"},
                                            { :url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/1597fcb9-5a54-449d-9b99-fc87564e1113.webm",
                                              :format=>"webm",
                                              :size=>704246,
                                              :resolution=>"r360p"},
                                            { :url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/a5519a7d-1e03-4b99-8446-eb04273ada83.webm",
                                              :format=>"webm",
                                              :size=>4292789,
                                              :resolution=>"source"}],
                                    :preview=>{:uuid=>"c13ed468-55ee-4281-bf4b-9a2115203c86",
                                               :size=>33884,
                                               :name=>nil,
                                               :source=>{:url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/a203e4e2-1ca3-4d62-a361-4ca5033fe45c.jpeg",
                                                         :width=>720,
                                                         :height=>1280},
                                               :thumb=>{:url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/91133554-1e86-4034-92ac-3b42d28f1aae.jpeg",
                                                        :width=>158,
                                                        :height=>280}},
                                               :screenshots=>[{ :uuid=>"c6509e64-7191-4f3d-a1fe-c8abc8d9b669",
                                                                :size=>33914,
                                                                :name=>nil,
                                                                :source=> {:url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/9ba7a208-5ab1-47ce-8f86-220fb89ed237.jpeg",
                                                                           :width=>720,
                                                                           :height=>1280},
                                                                :thumb=> {:url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/c398defd-b770-4acd-b1ae-9cabb0b3ad75.jpeg",
                                                                           :width=>158,
                                                                           :height=>280}},
                                                              { :uuid=>"c13ed468-55ee-4281-bf4b-9a2115203c86",
                                                                :size=>33884,
                                                                :name=>nil,
                                                                :source=>{:url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/a203e4e2-1ca3-4d62-a361-4ca5033fe45c.jpeg",
                                                                          :width=>720,
                                                                          :height=>1280},
                                                                :thumb=>{:url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/91133554-1e86-4034-92ac-3b42d28f1aae.jpeg",
                                                                         :width=>158,
                                                                         :height=>280}},
                                                              { :uuid=>"32c1f326-33fe-477e-aeba-8c5bf2a85ded",
                                                                :size=>29856,
                                                                :name=>nil,
                                                                :source=>{:url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/b513908d-b4ea-484d-823c-8ed49cf2415c.jpeg",
                                                                          :width=>720,
                                                                          :height=>1280},
                                                                :thumb=>{:url=>"https://storage-nginx.stage.govermedia.com/test-bucket/test_files/e6839727-9e61-41e8-a1a5-c190f5343cb0.jpeg",
                                                                         :width=>158,
                                                                         :height=>280}}],
                                                  :name=>nil,
                                                  :embed_url=>"https://govermedia.com/embed_video/?uuid=0e4d7d8c-a8f5-49da-94cd-d9811ec01d78", :provider=>"govermedia"}}
            Request.new(response)
          end

          def mocked_image_sync_request(params)
            uuid = params[:aws_file_uuid] ? params[:aws_file_uuid] : params[:uuid]
            response = {data:  {uuid: uuid,
                                size: 12254,
                                name: "test_image.jpg",
                                source: { url: "https://storage-nginx.stage.govermedia.com/test-bucket/test_files/7f7e7aa3-5ed7-4120-b843-45d19f65bee6.jpeg",
                                           width: 313,
                                           height: 315},
                                thumb:  { url: "https://storage-nginx.stage.govermedia.com/test-bucket/test_files/2523c7ca-cdaa-4599-8a46-e949335738a3.jpeg",
                                          width: 278,
                                          height: 280}}}
             Request.new(response)
          end

          def mocked_document_sync_request(params)
            uuid = params[:aws_file_uuid] ? params[:aws_file_uuid] : params[:uuid]
            response = {data:  {url: "https://storage-nginx.stage.govermedia.com/test-bucket/test_files/95d5edfe-1f17-422d-85c7-69f63e00c3fe.mp4",
                                uuid: "c147f0aa-f0e3-42da-ab0e-28895dc21ea1",
                                size: 245779,
                                name: "document.pdf"}}
             Request.new(response)
          end
      end
    end
  end
end
