# S3MediaServerApi - - a Ruby client for the S3 Media Server

S3MediaServerApi helps you write apps that need to interact with S3 Media Server.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3_media_server_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3_media_server_api

## Usage
### Available resources

#### S3MediaServerApi::Uploader
```ruby
#TODO : add example
```
#### S3MediaServerApi::Media::Document
Use S3MediaServerApi::Media::Document to interact Document resource
```ruby
# if you want create document from file path, use create method
created_document = S3MediaServerApi::Media::Document.create('/Users/ayrat/Development/s3_media_server_api/tmp/sample_mpeg4.mp4')


# to resolve document, use resolve method
resolved_document = S3MediaServerApi::Media::Document.resolve(created_document.uuid)

# both methods create and resolve return document object

resolved_document.uuid # uuid of document
resolved_document.url  # url of document
resolved_document.size # size of document
resolved_document.name  # url of document

# use destroy method, to destroy document
# this method is asynchronous, so it doesn't return anything
S3MediaServerApi::Media::Document.destroy(created_document.uuid)
```
#### S3MediaServerApi::Media::Image
Use S3MediaServerApi::Media::Image to interact Image resource
```ruby
# if you want create image from file path, use create method
created_image = S3MediaServerApi::Media::Image.create('/Users/ayrat/Development/s3_media_server_api/tmp/test_image.jpg')

# to resolve image, use resolve method
resolved_image = S3MediaServerApi::Media::Image.resolve(created_image.uuid)

# both methods create and resolve return document object
resolved_image.size
resolved_image.name
resolved_image.uuid
resolved_image.source.url
resolved_image.source.width
resolved_image.source.height

# to create thumb of image, use resize method.
# this method is asynchronous
S3MediaServerApi::Media::Image.resize(created_image.uuid)

# after thumb is created, new attributes will be available
thumbed_image = S3MediaServerApi::Media::Image.resolve(created_image.uuid)
thumbed_image.thumb.url
thumbed_image.thumb.width
thumbed_image.thumb.height

# to copy image, use copy method
copied_image = S3MediaServerApi::Media::Image.copy(created_image.uuid)

# to destroy image, use destroy method
S3MediaServerApi::Media::Image.destroy(created_image.uuid)
```
#### S3MediaServerApi::Media::Audio
Use S3MediaServerApi::Media::Audio to interact Audio resource
```ruby
# to create audio file from its path, use create method
created_audio = S3MediaServerApi::Media::Audio.create('/Users/ayrat/Development/s3_media_server_api/tmp/music_test.mp3')
# to resolve image, use resolve method
resolved_audio = S3MediaServerApi::Media::Audio.resolve(created_audio.uuid)

# both methods create and resolve return audio object
resolved_audio.url
resolved_audio.uuid
resolved_audio.name
resolved_audio.size

# cut method sends request to create audio sampel
# parameters: uuid - uuid of file
#             audio_url - url of audio file
#             duration  - duration of cutted file
#             start_position - position where cut wil be made
S3MediaServerApi::Media::Audio.cut(created_audio.uuid, created_audio.url, 20, 40)

# after audio is cutted, new attributes will be available
cutted_audio = S3MediaServerApi::Media::Audio.resolve(created_audio.uuid)

cutted_audio.sample_url
cutted_audio.duration
cutted_audio.sample_duration

# destroys audio file
S3MediaServerApi::Media::Audio.destroy(created_audio.uuid)
```
#### S3MediaServerApi::Media::Video
Use S3MediaServerApi::Media::Video to interact Video resource
```ruby
# to create video from its path, use create method
video = S3MediaServerApi::Media::Video.create('/Users/ayrat/Development/s3_media_server_api/tmp/sample_mpeg4.mp4')

# to resolve video, use resolve method
video = S3MediaServerApi::Media::Video.resolve(video.uuid)

# both methods create and resolve return video object
video.

video.name
video.embed_url
video.transcoded # true if video has all versions
                 # false otherwise

# after screenshots are made, screenshots attributes will be available with 3 screenshots
video = S3MediaServerApi::Media::Video.resolve(video.uuid)
video.screenshots[0].source.url
video.screenshots[0].source.width
video.screenshots[0].source.height
video.screenshots[0].thumb.url
video.screenshots[0].thumb.width
video.screenshots[0].thumb.height

# you can get available video versions in version attribute

video.versions[0].format
video.versions[0].resolution
video.versions[0].url
video.versions[0].size


```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/s3_media_server_api.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
