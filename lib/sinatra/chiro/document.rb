module Sinatra
  module Chiro
    class Documentation

      def initialize(opts={})
        @documentation = opts[:documentation[0]] || Sinatra::Chiro.class_variable_get('@@documentation')
      end

      def show(env)
        verb, url = env['sinatra.route'].split('/')
        endpoint = @documentation.select { |d| d.path.include?(url) }.flatten.first
        raise "Path #{url} doesn't have any docs" unless endpoint

        response_body = [endpoint.to_json]

        return response_body
      end
    end
  end
end

