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
        return @app.call(env) unless show_help

        path = env['PATH_INFO']
        docs = @documentation.select { |d| d.path.include?(path)}.flatten.first
        raise "Path #{path} doesn't have any documentation" unless docs

        response_body = [docs.to_json]

        [200, {'Content-Type' => 'application/json'}, response_body]
      end
    end
  end
end
