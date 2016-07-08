require 'test_helper'

class S3MediaServerApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::S3MediaServerApi::VERSION
  end
  
  def test_aws_file_response
    aws_file = S3MediaServerApi::Uploader.upload('/Users/ayrat/Development/s3_media_server_api/tmp/test_image.jpg')
    assert aws_file.uuid, 'uuid wasnt set'
    assert aws_file.size, 'size wasnt set'
    assert aws_file.mime_type, 'mime_type wasnt set'
    assert aws_file.uploads_count, 'uploads_count wasnt set'
    assert aws_file.default_part_size, 'default_part_size wasnt set'
    assert aws_file.state, 'state wasnt set'
    assert aws_file.public_url, 'public_url wasnt set'
    assert aws_file.name, 'name wasnt set'
  end

  def test_image_api
    created_image = S3MediaServerApi::Media::Image.create('/Users/ayrat/Development/s3_media_server_api/tmp/test_image.jpg')
    assert created_image.uuid
    assert created_image.size
    assert created_image.name
    assert created_image.uuid
    assert created_image.source.url

    resolved_image = S3MediaServerApi::Media::Image.resolve(created_image.uuid)
    assert resolved_image.size
    assert resolved_image.name
    assert resolved_image.uuid
    assert resolved_image.source.url
    assert_equal resolved_image.source.url, created_image.source.url


    S3MediaServerApi::Media::Image.resize(created_image.uuid)
    sleep(10)
    thumbed_image = S3MediaServerApi::Media::Image.resolve(created_image.uuid)
    assert thumbed_image.thumb.url
    assert thumbed_image.thumb.width
    assert thumbed_image.thumb.height


    copied_image = S3MediaServerApi::Media::Image.copy(created_image.uuid)
    assert copied_image.size
    assert copied_image.name
    assert copied_image.uuid
    assert copied_image.source.url
    assert copied_image.source.width
    assert copied_image.source.height
    assert copied_image.thumb.url
    assert copied_image.thumb.width
    assert copied_image.thumb.height

    S3MediaServerApi::Media::Image.destroy(created_image.uuid)
    S3MediaServerApi::Media::Image.destroy(copied_image.uuid)
  end

  def test_document_api
    created_document = S3MediaServerApi::Media::Document.create('/Users/ayrat/Development/s3_media_server_api/tmp/sample_mpeg4.mp4')

    resolved_document = S3MediaServerApi::Media::Document.resolve(created_document.uuid)
    assert resolved_document.uuid
    assert resolved_document.url
    assert resolved_document.size
    assert resolved_document.name

    S3MediaServerApi::Media::Document.destroy(created_document.uuid)
  end

  def test_audio_api
    created_audio = S3MediaServerApi::Media::Audio.create('/Users/ayrat/Development/s3_media_server_api/tmp/music_test.mp3')
    resolved_audio = S3MediaServerApi::Media::Audio.resolve(created_audio.uuid)
    assert resolved_audio.url
    assert resolved_audio.uuid
    assert resolved_audio.name
    assert resolved_audio.size

    S3MediaServerApi::Media::Audio.cut(created_audio.uuid, created_audio.url, 20, 40)
    sleep(10)
    cutted_audio = S3MediaServerApi::Media::Audio.resolve(created_audio.uuid)
    assert cutted_audio.url
    assert cutted_audio.uuid
    assert cutted_audio.name
    assert cutted_audio.size
    assert cutted_audio.sample_url
    assert cutted_audio.duration
    assert cutted_audio.sample_duration

    S3MediaServerApi::Media::Audio.destroy(created_audio.uuid)
  end
end
