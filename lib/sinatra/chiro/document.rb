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

        [endpoint.query_params, endpoint.named_params, endpoint.forms].each do |param|
          param.each do |hash|
            commenter = hash[:commenter]
            hash[:comment] = commenter.comment(hash[:type]) unless commenter.nil?
          end
        end

        [endpoint]
      end


      def routes(env)
        _, path = env['sinatra.route'].split

        endpoints.each do |endpoint|
          [endpoint.query_params, endpoint.named_params, endpoint.forms].each do |param|
            param.each do |hash|
              commenter = hash[:commenter]
              hash[:comment] = commenter.comment(hash[:type]) unless commenter.nil?
            end
          end
        end

        endpoints
      end

    end
  end
end


