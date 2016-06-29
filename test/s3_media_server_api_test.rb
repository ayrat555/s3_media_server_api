require 'test_helper'

class S3MediaServerApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::S3MediaServerApi::VERSION
  end

  def test_image_api
    response = S3MediaServerApi::Media::Image.create('/Users/ayrat/Development/s3_media_server_api/tmp/test_image.jpg')
    uuid = response[:data][:uuid]
    assert response.success?
    resolve_response = S3MediaServerApi::Media::Image.resolve(uuid)
    assert resolve_response.success?, 'Can not resolve image'

    S3MediaServerApi::Media::Image.resize(uuid)
    sleep(10)
    resolve_response = S3MediaServerApi::Media::Image.resolve(uuid)
    assert resolve_response[:data][:thumb], 'Thumb wasnt made'

    copy_response = S3MediaServerApi::Media::Image.copy(uuid)
    assert copy_response.success?, 'Image wasnt copied'
    copy_uuid = copy_response[:data][:uuid]

    S3MediaServerApi::Media::Image.destroy(uuid)
    S3MediaServerApi::Media::Image.destroy(copy_uuid)
    sleep(2)
    resolve_response = S3MediaServerApi::Media::Image.resolve(uuid)
    assert_equal "unprocessable_entity", resolve_response.status, 'Image wasnt destroyed'
  end
  #
  def test_video_api
    response = S3MediaServerApi::Media::Video.create('/Users/ayrat/Development/s3_media_server_api/tmp/sample_mpeg4.mp4')
    uuid = response[:data][:uuid]
    assert response.success?
    resolve_response = S3MediaServerApi::Media::Video.resolve(uuid)
    assert resolve_response.success?, 'Can not resolve video'
    S3MediaServerApi::Media::Video.destroy(uuid)
    sleep(5)
    resolve_response = S3MediaServerApi::Media::Video.resolve(uuid)
    assert resolve_response.fail?
  end

  def test_document_api
    response = S3MediaServerApi::Media::Document.create('/Users/ayrat/Development/s3_media_server_api/tmp/sample_mpeg4.mp4')
    uuid = response[:data][:uuid]
    assert response.success?
    resolve_response = S3MediaServerApi::Media::Document.resolve(uuid)
    assert resolve_response.success?, 'Can not resolve document'
    S3MediaServerApi::Media::Document.destroy(uuid)
    sleep(5)
    resolve_response = S3MediaServerApi::Media::Document.resolve(uuid)
    assert_equal "unprocessable_entity", resolve_response.status, 'Document wasnt destroyed'
  end

  def test_audio_api
    response = S3MediaServerApi::Media::Audio.create('/Users/ayrat/Development/s3_media_server_api/tmp/music_test.mp3')
    uuid = response[:data][:uuid]
    assert response.success?
    resolve_response = S3MediaServerApi::Media::Audio.resolve(uuid)
    assert resolve_response.success?, 'Can not resolve audio'

    S3MediaServerApi::Media::Audio.cut(uuid, response[:data][:url], 20, 40)
    sleep(10)
    resolve_response = S3MediaServerApi::Media::Audio.resolve(uuid)
    assert resolve_response[:data][:sample_url], 'Audio wasnt cutted'

    S3MediaServerApi::Media::Audio.destroy(uuid)
    sleep(5)
    resolve_response = S3MediaServerApi::Media::Audio.resolve(uuid)
    assert_equal "unprocessable_entity", resolve_response.status, 'Audio wasnt destroyed'
  end
end
