# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3_media_server_api/version'

Gem::Specification.new do |spec|
  spec.name          = "s3_media_server_api"
  spec.version       = S3MediaServerApi::VERSION
  spec.authors       = ["Ayrat Badykov"]
  spec.email         = ["ayratin555@gmail.com"]

  spec.summary       = 'S3MediaServerApi helps you write apps that need to interact with S3 Media Server.'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_dependency 'asynk', '>= 0.0.1'
  spec.add_dependency 'parallel'
  spec.add_dependency 'mimemagic'
  spec.add_dependency 'faraday'
  spec.add_dependency 'curb'
  spec.add_dependency 'simple_file_uploader'
end
