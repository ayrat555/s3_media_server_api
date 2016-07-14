require 'yaml'

module S3MediaServerApi
  class ConfigError < S3MediaServerApiError; end
  class Config
    class << self
      def add_config(name, default_value = nil)

        define_singleton_method "#{name}=".to_sym do |value|
          instance_variable_set("@#{name}".to_sym,value)
        end

        define_singleton_method "#{name}".to_sym do
          value = instance_variable_get(:"@#{name}")
          raise ConfigError.new("Key: '#{name}' cannot be nil.")  if @required_keys.include?(name.to_sym) && value.nil?
          value
        end

        self.send("#{name}=".to_sym, default_value)
      end

      def required(*args)
        @required_keys = args
      end

      def configure
        yield self
        @required_keys.each do |key|
          raise ConfigError.new("Key: #{key} cannot be nil.") if instance_variable_get(:"@#{key}").nil?
        end
      end
    end

    add_config :mocked
    add_config :cache_class, S3MediaServerApi::Cache
    add_config :upload_thread_count, 4

    required :mocked, :cache_class, :upload_thread_count
  end
end
