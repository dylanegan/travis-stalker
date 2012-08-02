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
      # 
      def initialize(pusher_token, projects=[])
        @socket    = PusherClient::Socket.new(pusher_token)
        @projects = projects
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

      def notify(notification)
        if projects.empty? || projects.include?(notification[:title])
          Travis::Stalker.log({ notifying: true }.merge(notification))
          TerminalNotifier.notify(notification.delete(:message), notification)
        else
          Travis::Stalker.log({ notifying: false }.merge(notification))
        end
      end
    end
  end
end
