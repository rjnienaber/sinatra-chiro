module Sinatra
  module Chiro
    class Documentation

      attr_reader :endpoints

      def initialize(endpoints)
        @endpoints = endpoints
      end

      def document(env)
        path_array = env['sinatra.route'].split('/')[1..-1]
        endpoint = endpoints.select { |d| d.path.split('/')[1..-1] == path_array}.flatten.first
        raise "Path #{path_array} doesn't have any docs" unless endpoint
        endpoint
      end
    end
  end
end

