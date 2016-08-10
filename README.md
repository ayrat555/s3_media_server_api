# S3MediaServerApi - a Ruby client for the S3 Media Server

S3MediaServerApi helps you write apps that need to interact with S3 Media Server.

NOTE: This gem was used in my previous company's internal projects. It requires s3_media_server project that currently isn't open source
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

#### S3MediaServerApi::Media::Document
Use S3MediaServerApi::Media::Document to interact with Document resource
```ruby
# to create document from existing aws file uuid, use create method
document = S3MediaServerApi::Media::Document.create("4edbfdf9-9517-4902-8e92-2212215b0de5")

# if you want create document from file path, use create method
created_document = S3MediaServerApi::Media::Document.create_from_path('/Users/ayrat/Development/s3_media_server_api/tmp/sample_mpeg4.mp4')


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
Use S3MediaServerApi::Media::Image to interact with  Image resource
```ruby
# to create image from existing aws file uuid, use create method
image = S3MediaServerApi::Media::Image.create("4edbfdf9-9517-4902-8e92-2212215b0de5")

# if you want create image from file path, use create method
created_image = S3MediaServerApi::Media::Image.create_from_path('/Users/ayrat/Development/s3_media_server_api/tmp/test_image.jpg')

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
# this method is asynchronous
S3MediaServerApi::Media::Image.destroy(created_image.uuid)
```
#### S3MediaServerApi::Media::Audio
Use S3MediaServerApi::Media::Audio to interact with Audio resource
```ruby
# to create audio from existing aws file uuid, use create method
audio = S3MediaServerApi::Media::Audio.create("4edbfdf9-9517-4902-8e92-2212215b0de5")

# to create audio file from its path, use create method
created_audio = S3MediaServerApi::Media::Audio.create_from_path('/Users/ayrat/Development/s3_media_server_api/tmp/music_test.mp3')
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
# this method is asynchronous
cut_params = { duration: 20,
               start_position: 40}
S3MediaServerApi::Media::Audio.cut(created_audio.uuid, cut_params)

# after audio is cutted, new attributes will be available
cutted_audio = S3MediaServerApi::Media::Audio.resolve(created_audio.uuid)

cutted_audio.sample_url
cutted_audio.duration
cutted_audio.sample_duration

# destroys audio file
# this method is asynchronous
S3MediaServerApi::Media::Audio.destroy(created_audio.uuid)
```
#### S3MediaServerApi::Media::Video
Use S3MediaServerApi::Media::Video to interact with Video resource
```ruby
# to create video from existing aws file uuid, use create method
video = S3MediaServerApi::Media::Video.create("4edbfdf9-9517-4902-8e92-2212215b0de5")

# to create video from its path, use create method
video = S3MediaServerApi::Media::Video.create_from_path('/Users/ayrat/Development/s3_media_server_api/tmp/sample_mpeg4.mp4')

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

# to destroy video, use destroy method
# this method is asynchronous
S3MediaServerApi::Media::Video.destroy(video.uuid)
```

#### S3MediaServerApi::Media::Collection
Use S3MediaServerApi::Media::Collection to interact with Collection resource
```ruby
# to create Collection, use create method
# provide uuid of collection owner
owner_uuid = "4edbfdf9-9517-4902-8e92-2212215b0de5"
collection = S3MediaServerApi::Media::Collection.create(owner_uuid)

# to add new element to the collection, use add_item method
# firstly create aws_file then provide its uuid and kind of media you want to create
# method returns media file object that was created
# available media types
#                      images, documents, videos, audios
params = { kind: 'images', media_file_uuid: aws_file.uuid }
image =  S3MediaServerApi::Media::Collection.add_item(collection.uuid, params)

# to resolve document, use resolve method
resolved_collection = S3MediaServerApi::Media::Collection.resolve(created_collection.uuid)

# both methods create and resolve return collection object

resolved_collection.uuid # uuid of the collection
resolved_collection.owner_uuid  # uuid of the collection owner
resolved_collection.videos # array of videos
resolved_collection.documents  # array of documents
resolved_collection.images  # array of images
resolved_collection.audios  # array of audio files
# NOTE: video, document, image and audio objects are described above

# use destroy method, to destroy collection
# this method is asynchronous, so it doesn't return anything
S3MediaServerApi::Media::Colllection.destroy(created_collection.uuid)
```

#### AwsFile
```ruby
# to create aws file from its path, use upload method from S3MediaServerApi::Uploader module
aws_file = S3MediaServerApi::Uploader.upload('/Users/ayrat/Development/s3_media_server_api/tmp/test_image.jpg')

# to create aws file from its url, use upload_from_url method from S3MediaServerApi::Uploader module
image_url = "https://d2l3jyjp24noqc.cloudfront.net/uploads/image/img/269/Test-Driven_APIs_with_Phoenix_and_Elixir.png"
file = S3MediaServerApi::Uploader.upload_from_url(image_url)

# to resolve aws file, use resolve method
resolved_aws_file =  S3MediaServerApi::AwsFile.resolve(aws_file.uuid)

# both S3MediaServerApi::Uploader.upload and S3MediaServerApi::AwsFile.resolve return aws file object
aws_file.uuid
aws_file.size
aws_file.mime_type
aws_file.uploads_count
aws_file.default_part_size
aws_file.state
aws_file.public_url
aws_file.name

```
NOTE: you can't remove aws file without creating media resource

## Configuration

You can configure the following values by overriding these values using S3MediaServerApi::Config.configure method.

```ruby
# in how many threads file will be uploaded
# by default upload_thread_count value is 4
upload_thread_count
# class that will cache queries to S3 Media Server
cache_class
# to mock all request set mock to true
mock
```

Example
```ruby

S3MediaServerApi::Config.configure do |config|
  config.upload_thread_count = 10
  config.mock = true
end
```

#### Configuring cache class

Define class with class method fetch
```ruby

class Infrastructure::S3MediaServerCacheService

  class << self
    def fetch(key, params={}, &block)
      Rails.cache.fetch(key, expires_in: 24.hours) do
        yield
      end
    end
  end
end

```
Then override cache_class in S3MediaServerApi::Config.configure
```ruby

S3MediaServerApi::Config.configure do |config|
  config.cache_class = Infrastructure::S3MediaServerCacheService
end
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/s3_media_server_api.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
