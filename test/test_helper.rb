$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 's3_media_server_api'

require 'minitest/autorun'

Asynk::Broker.connect
