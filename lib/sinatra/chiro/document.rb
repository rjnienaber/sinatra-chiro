module Sinatra
  module Chiro
    class Documentation

      attr_reader :endpoints

      def initialize(endpoints)
        @endpoints = endpoints
      end

      def document(env)
        _, path = env['sinatra.route'].split
        endpoint = endpoints.select { |d| d.path == path}.flatten.first
        raise "Path #{path} doesn't have any docs" unless endpoint
        [[endpoints[0].appname, [endpoint]]]
      end

      def routes(env)
        #endpoints.each do |endpoints|
        #  endpoints
        #end
        pp endpoints[0].description
        [endpoints[0].appname, endpoints]

      end
    end
  end
end


