require 'googleauth'

module Maia
  module FCM
    class Credentials
      SCOPE = 'https://www.googleapis.com/auth/firebase.messaging'.freeze

      def initialize(path = ENV['GOOGLE_APPLICATION_CREDENTIALS'])
        @path = path
      end

      def project
        to_h['project_id']
      end

      def token
        credentials.fetch_access_token!['access_token']
      end

      def to_h
        @to_h ||= JSON.parse file.read
      end

      private
        def file
          if @path && File.exist?(@path)
            File.new @path
          else
            raise Maia::Error::NoCredentials
          end
        end

        def credentials
          @credentials ||= Google::Auth::ServiceAccountCredentials.make_creds(
            json_key_io: file,
            scope: SCOPE
          )
        end
    end
  end
end
