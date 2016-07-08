module S3MediaServerApi
  module Media
    class Audio < CommonMediaApi
      AUDIO = 'audio'

      def sample_url
        @params[:sample_url]
      end

      def url
        @params[:url]
      end

      def sample_url
        @params[:sample_url]
      end

      def duration
        @params[:duration]
      end

      def sample_duration
        @params[:sample_duration]
      end

      class << self
        def create(path)
          Audio.new(super(path))
        end

        def resolve(uuid)
          Audio.new(super(uuid))
        end
        #
        # sends request to cut audio file
        # parameters: uuid - uuid of file
        #             audio_url - url of audio file
        #             duration  - duration of audio file
        #             start_position - position where cut wil be made
        #
        def cut(uuid, audio_url, duration, start_position)
          params = {
                     uuid: uuid,
                     audio_url: audio_url,
                     duration: duration,
                     start_position: start_position
                    }
          custom_async_request(:cut, params)
        end

        private
          def media_type; AUDIO; end
      end
    end
  end
end
