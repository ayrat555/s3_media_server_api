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

      def duration
        @params[:duration]
      end

      def sample_duration
        @params[:sample_duration]
      end

      class << self
        #
        # sends request to cut audio file
        # parameters: uuid - uuid of file
        #             duration  - duration of audio file
        #             start_position - position where cut wil be made
        #
        def cut(uuid, duration:, start_position:)
          return unless uuid
          params = {
                     uuid: uuid,
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
