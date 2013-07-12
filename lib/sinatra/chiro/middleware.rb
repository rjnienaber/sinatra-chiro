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

        response = validate(url, env)
        return response if response

        @app.call(env)
      end

      def generate_help(url)
        endpoint = @documentation.select { |d| d.path.include?(url) }.flatten.first
        raise "Path #{url} doesn't have any docs" unless endpoint

        response_body = [endpoint.to_json]

        [200, {'Content-Type' => 'application/json'}, response_body]
      end

      def validate(url, env)

        query_string = env['QUERY_STRING']
        query_hash = Rack::Utils.parse_nested_query("#{query_string}")

       errors = []
=begin
        query_hash.each do |k, v|
          unless k == 'people'
            @message = "#{k} parameter must be a String" if k.type != String
          else
            @message = "people parameter must be an Array" if k.type != Array
          end
        end
=end

        ['language', 'year', 'people', 'greeting'].each do |parameter|
          errors << "must include a #{parameter} parameter" if query_hash[parameter] == nil
        end

        query_hash.each do|k,v|
          errors << "#{k} is not a valid parameter" if (k!="language" and k!="people" and k!="greeting" and k!="year")
        end

        [200, {'Content-Type' => 'text/plain'}, [errors.join("\n")]] if !errors.empty?


        #find the endpoint using the 'url'
        ## if there is no endpoint, just return
        #get all the query string parameters from the endpoint
        #pull query string parameters from 'env'

        #check that there are no extra parameters
        #check that all required parameters are present
        #check that parameters is of the right type


      end
    end
  end
end
