require "travis/stalker/charlie"
require "travis/stalker/version"

module Travis
  module Stalker
    module Logger
      def self.log(data, &block)
        STDOUT.puts data
        yield if block_given?
      end
    end

    # Public: Allows the user to specify a logger for the log messages that Travis::Stalker
    # produces.
    #
    # logger = The object you want logs to be sent too
    #
    # Examples
    #
    #   Travis::Stalker.instrument_with(STDOUT.method(:puts))
    #   # => #<Method: IO#puts>
    #
    # Returns the logger object
    def self.instrument_with(logger)
      @logger = logger
    end

    # Internal: Top level log method for use by Travis::Stalker
    #
    # data = Logging data (typically a hash)
    # blk  = block to execute
    #
    # Returns the response from calling the logger with the arguments
    def self.log(data, &blk)
      logger.call({ 'travis-stalker' => true }.merge(data), &blk)
    end

    # Public: The logging location
    #
    # Returns an Object
    def self.logger
      @logger || Travis::Stalker::Logger.method(:log)
    end
  end
end
