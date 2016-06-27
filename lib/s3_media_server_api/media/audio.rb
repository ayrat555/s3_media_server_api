module S3MediaServerApi
  module Media
    class Audio
      AUDIO = 'audio'

      class << self

        def create(path)
          CommonMediaApi.create(path, AUDIO)
        end

        def resolve(uuid)
          CommonMediaApi.resolve(uuid, AUDIO)
        end

        def destroy(uuid)
          CommonMediaApi.destroy(uuid, AUDIO)
        end

        def cut(uuid, audio_url, duration, start_position)
          Asynk::Publisher.publish('media_processor.audio.cut', uuid: uuid,
                                                                audio_url: audio_url,
                                                                duration: duration,
                                                                start_position: start_position)
        end
      end
    end
  end
end
