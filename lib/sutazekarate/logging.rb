require 'logger'

module Sutazekarate
  module Logging
    def logger
      @logger ||= ActiveSupport::Logger.new(STDERR)
        .tap { |logger| logger.formatter = ::Logger::Formatter.new }
        .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
        .then { |logger| logger.tagged(self.class.to_s) }
    end
  end
end
