module Sinatra
  module Chiro
    class Middleware



      def initialize(app, opts={})
        @app = app
        @documentation = opts[:documentation] || Sinatra::Chiro.class_variable_get('@@documentation')
      end
      def call(env)
        query_string = env['QUERY_STRING']
        show_help = query_string.include?('help')
        url = env['PATH_INFO']

        return @app.call(env) if url.include?('favicon.ico')

        if show_help
          return generate_help(url)
        end


        @app.call(env)
      end

      def generate_help(url)
        endpoint = @documentation.select { |d| d.path.include?(url) }.flatten.first
        raise "Path #{url} doesn't have any docs" unless endpoint

        response_body = [endpoint.to_json]

        [200, {'Content-Type' => 'application/json'}, response_body]
      end



    end
  end
end
