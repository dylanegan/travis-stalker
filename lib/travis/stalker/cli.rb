require "clamp"
require "scrolls"
require "travis/stalker"

module Travis
  module Stalker
    module CLI
      class Logger
        def self.log(data, &block)
          Scrolls.log(data, &block)
        end
      end

      def self.run(*a)
        MainCommand.run(*a)
      end

      class AbstractCommand < Clamp::Command
        option ["--pusher-token"], "PUSHER_TOKEN", "pusher token id", :default => "23ed642e81512118260e"
        option ["--projects"], "PROJECTS", "comma separated list of projects to stalk", :default => [] do |projects|
          projects.split(',')
        end
        option "--regex", :flag, :default => false

        option "--version", :flag, "show version" do
          puts "travis-stalker #{Travis::Stalker::VERSION}"
          exit 0
        end
      end

      class MainCommand < AbstractCommand
        def execute
          stalker = Travis::Stalker::Charlie.new(pusher_token, projects, regex?)
          stalker.start
        end
      end
    end
  end
end

Travis::Stalker.instrument_with(Travis::Stalker::CLI::Logger.method(:log))
