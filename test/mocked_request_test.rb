require 'test_helper'

class MockedRequestTest < Minitest::Test
  def setup
    S3MediaServerApi::Config.configure do |config|
      config.mocked = true
    end
  end

  def test_audio_consumers
     audio = S3MediaServerApi::Media::Audio.create('/Users/ayrat/Development/s3_media_server_api/tmp/music_test.mp3')
     assert audio.uuid
     audio = S3MediaServerApi::Media::Audio.resolve('555')
     assert audio.sample_url
     cut_params = { audio_url: "asdfasdfa",
                    duration: 20,
                    start_position: 40}
     assert S3MediaServerApi::Media::Audio.cut(555, cut_params)
  end

  def test_video_consumers
     video = S3MediaServerApi::Media::Video.create('/Users/ayrat/Development/s3_media_server_api/tmp/music_test.mp3')
     assert video.versions[0].url
     assert video.uuid
     video = S3MediaServerApi::Media::Video.resolve(555)
     assert video.screenshots[0]
  end

  def test_image_consumers
     image = S3MediaServerApi::Media::Image.create('/Users/ayrat/Development/s3_media_server_api/tmp/music_test.mp3')
     assert image.source
     image = S3MediaServerApi::Media::Image.resolve(555)
     assert image.uuid
     image = S3MediaServerApi::Media::Image.copy(555)
     assert image.size
     assert S3MediaServerApi::Media::Image.resize(555)
  end

  def test_document_consumers
     document = S3MediaServerApi::Media::Document.create('/Users/ayrat/Development/s3_media_server_api/tmp/music_test.mp3')
     assert document.size
     document = S3MediaServerApi::Media::Document.resolve(555)
     assert document.name
     assert document.uuid
     assert S3MediaServerApi::Media::Document.destroy(555)
  end
end
