require 'test_helper'

class ConfigurationTest < Minitest::Test

  def test_should_set_valid_configuration
    S3MediaServerApi::Config.configure do |config|
      config.upload_thread_count = 10
    end

    assert_equal S3MediaServerApi::Cache, S3MediaServerApi::Config.cache_class
    assert_equal 10, S3MediaServerApi::Config.upload_thread_count
  end
end
