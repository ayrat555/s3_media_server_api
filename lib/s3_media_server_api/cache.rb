module S3MediaServerApi
  class Cache
    class << self
      def fetch(key, params = {}, &block)
        yield
      end
    end
  end
end
