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
          when /s3_media_server.media.(collection).(\.*)/
            mocked_collection_sync_request(params)
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
            uuid = params[:aws_file_uuid] ? params[:aws_file_uuid] : params[:uuid]
            response = {:data=>{:duration=>6.037,
                                :transcoded=>true,
                                :uuid=>uuid,
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

          def mocked_collection_sync_request(params)
            response = {:data=>{:videos=>[{:duration=>104.50999999999999,
                                           :transcoded=>true,
                                           :uuid=>"597e7538-3455-4ec2-b234-0cc4bc6c4870",
                                           :versions=>[{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/ccbb152c-328b-4f2d-bc09-aefc16416698.mp4", :format=>"mp4", :size=>12300035, :resolution=>"r480p"}, {:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/e2de9962-99da-4d4e-8eb8-80d6d38e2526.mp4", :format=>"mp4", :size=>5796575, :resolution=>"r240p"}, {:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/7773219c-feb4-43cf-927a-7b63d5638884.mp4", :format=>"mp4", :size=>9447976, :resolution=>"r360p"}, {:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/cf52bc8a-976c-453d-9208-f998e014e9c4.webm", :format=>"webm", :size=>4079234, :resolution=>"r240p"}, {:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/b5f5555c-9358-46b4-92fd-07a1fc06cc25.mp4", :format=>"mp4", :size=>29609393, :resolution=>"r720p"}, {:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/c27ee433-c380-48ae-9507-23fccac2d115.webm", :format=>"webm", :size=>11323327, :resolution=>"r480p"}, {:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/ed96c629-0ca8-4a07-ab30-81ff085b8560.webm", :format=>"webm", :size=>21693633, :resolution=>"r720p"}, {:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/644ba3fb-cc25-46fb-8e80-3a58a6554648.webm", :format=>"webm", :size=>8039883, :resolution=>"r360p"}],
                                           :preview=>{:uuid=>"1e271fe0-5645-4ce2-bcdc-db0f93cf26d7", :size=>68287, :name=>nil, :source=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/5f30a9f3-b9a3-4b2f-8fac-86cb2c128def.jpeg", :width=>1280, :height=>720}, :thumb=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/0ab76f9d-4633-4e24-9937-d0a7ebad5359.jpeg", :width=>nil, :height=>nil}},
                                           :screenshots=>[{:uuid=>"d96fc060-ccd0-4ce1-86f8-af11f59b82fb", :size=>68448, :name=>nil, :source=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/d2b24e87-5aee-4180-90b0-d80276ea9843.jpeg", :width=>1280, :height=>720}, :thumb=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/de3bf8ec-18c2-4039-823e-0f12ae9bed55.jpeg", :width=>nil, :height=>nil}}, {:uuid=>"1e271fe0-5645-4ce2-bcdc-db0f93cf26d7", :size=>68287, :name=>nil, :source=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/5f30a9f3-b9a3-4b2f-8fac-86cb2c128def.jpeg", :width=>1280, :height=>720}, :thumb=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/0ab76f9d-4633-4e24-9937-d0a7ebad5359.jpeg", :width=>nil, :height=>nil}}, {:uuid=>"ce174591-d297-43da-9cbd-00056f22dc29", :size=>64795, :name=>nil, :source=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/0f364891-37ae-4acd-b89f-e93ccbf9fd9d.jpeg", :width=>1280, :height=>720}, :thumb=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/b7094c5c-ae8b-447d-844b-00c3acbf4333.jpeg", :width=>440, :height=>248}}], :name=>"2c6d87a9-1d81-48e5-9282-81a76f1e942d.mp4", :embed_url=>"https://stage.govermedia.com/embed_video/?uuid=597e7538-3455-4ec2-b234-0cc4bc6c4870", :provider=>"govermedia"}],
                                :audios=>[{ url: "https://storage-nginx.stage.govermedia.com/test-bucket/test_files/#{SecureRandom.uuid}.mp3",
                                                    sample_url: "https://storage-nginx.stage.govermedia.com/test-bucket/test_files/#{SecureRandom.uuid}.mp3",
                                                    uuid: 'asfasfasfasfasf',
                                                    size: 704512,
                                                    sample_uploaded: true,
                                                    name: "music_test.mp3",
                                                    duration: 87.891875,
                                                    sample_duration: 19.983673}],
                                :documents=>[{url: "https://storage-nginx.stage.govermedia.com/test-bucket/test_files/95d5edfe-1f17-422d-85c7-69f63e00c3fe.mp4",
                                              uuid: "c147f0aa-f0e3-42da-ab0e-28895dc21ea1",
                                              size: 245779,
                                              name: "document.pdf"}],
                                :images=>[{:uuid=>"ccfac9dc-e208-4644-b932-18e1aae95f4f", :size=>312857, :name=>'image1.jpeg', :source=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/23b3d879-bc0c-47a1-aba5-2fcc20ee6872.png", :width=>600, :height=>437}, :thumb=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/589ea98b-1c90-46e4-a98f-0e42798a549c.jpeg", :width=>384, :height=>280}}, {:uuid=>"c1e43b8d-e593-466d-8aa1-0fdd56282052", :size=>83782, :name=>nil, :source=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/34ee64a7-bf47-4d47-8dc2-c3d8ae522087.png", :width=>836, :height=>546}, :thumb=>{:url=>"https://storage-nginx.stage.govermedia.com/gm-s2-f/files/89847cd4-4e88-4373-af53-54ad3d52fbdd.jpeg", :width=>429, :height=>280}}],
                                :uuid=>params[:uuid],
                                :owner_uuid=>"ee287478-d4d7-4731-a11e-d18cf8cfd1c5"}}
              Request.new(response)
          end
      end
    end
  end
end
