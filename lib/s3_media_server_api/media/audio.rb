module S3MediaServerApi
  module Media
    class Audio < CommonMediaApi
      AUDIO = 'audio'

      class << self

        def media_type; AUDIO; end

        def cut(uuid, audio_url, duration, start_position)
          params = {
                     uuid: uuid,
                     audio_url: audio_url,
                     duration: duration,
                     start_position: start_position
                    }
          custom_async_request(:cut, params)
        end
      end
    end
  end
end
