module Sinatra
  module Chiro
    class Documentation

      attr_reader :endpoints

      def initialize(endpoints)
        @endpoints = endpoints
      end

      def show(env)
        _, url = env['sinatra.route'].split('/')
        endpoint = endpoints.select { |d| d.path.include?(url) }.flatten.first
        raise "Path #{url} doesn't have any docs" unless endpoint

        response_body = [endpoint.to_json]

        return response_body
      end
    end
  end
end

