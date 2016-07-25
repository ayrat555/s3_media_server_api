module S3MediaServerApi
  module Consumers
    module ConsumerHelper
      def handle_exception(ex)
        bc = ActiveSupport::BacktraceCleaner.new
        bc.add_filter   { |line| line.gsub(Rails.root.to_s, '') } # strip the Rails.root prefix
        bc.add_silencer { |line| line =~ /mongrel|gems|minitest/ } # skip any lines from mongrel or rubygems
        array_of_trace  = bc.clean(ex.backtrace).map{|line| ["      ", line].join }
        array_of_trace.unshift("#{ex.class}: #{ex.message}")
        logger.error array_of_trace.join("\n")
      end
    end
  end
end
