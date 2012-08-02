gem "pusher-client-merman"

require "pusher-client"
PusherClient.logger.level = Logger::INFO
require "terminal-notifier"

module Travis
  module Stalker
    class Charlie
      attr_accessor :projects

      # Initialize a new connection to travis feed
      #
      # publisher_token - pusher token id
      # projects - Array of projects to stalk
      # regex - if true then accept partial matches
      # 
      def initialize(pusher_token, projects=[], regex=false)
        @projects = projects
        @regex = regex
        @socket    = PusherClient::Socket.new(pusher_token)

        Travis::Stalker.log(regex: regex, projects: projects)
      end

      def regex?
        @regex
      end

      def start
        @socket.subscribe('common')
        @socket['common'].bind('build:finished') do |payload|
          notify(payload_to_notification(JSON.parse(payload)))
        end
        @socket.connect
      end

      private

      def payload_to_notification(payload)
        id      = payload['build']['id']
        number  = payload['repository']['last_build_number']
        result  = payload['build']['result'] == 0 ? 'PASSED' : 'FAILED'
        title   = payload['repository']['slug']
        message =  "Build ##{number} #{result}"
        url     = "http://travis-ci.org/#!/#{title}/builds/#{id}"
        { title: title, message: message, url: url }
      end

      def has_project?(project)
        return true if projects.empty?

        if regex?
          projects.find { |p| project[/#{p}/] }
        else
          projects.include?(project)
        end
      end

      def notify(notification)
        if has_project?(notification[:title])
          Travis::Stalker.log({ notifying: true }.merge(notification))
          TerminalNotifier.notify(notification[:message], { title: notification[:title], open: notification[:url] })
        else
          Travis::Stalker.log({ notifying: false }.merge(notification))
        end
      end
    end
  end
end
