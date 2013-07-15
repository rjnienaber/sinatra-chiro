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

        query_hash.each do |k, v|
          if k == 'people'
            errors << "people parameter must be an Array" if !v.is_a? Array
          else
            errors << "#{k} parameter must be a String" if v.is_a? Array
          end
        end

        ['language', 'year', 'greeting'].each do |parameter|
          errors << "must include a #{parameter} parameter" if query_hash[parameter] == nil
        end

        lang = query_hash['language']
        errors << "not a valid language" unless (lang=="en" or lang=="fr" or lang=="af-za") if lang !=nil

        year = query_hash['year']
        errors << "year must be a number" unless (year =~ /^[-+]?[0-9]+$/) if year !=nil

        query_hash.each do|k,v|
          errors << "#{k} is not a valid parameter" if (k!="language" and k!="people" and k!="greeting" and k!="year")
        end

        [200, {'Content-Type' => 'text/plain'}, [errors.join("\n")]] if !errors.empty?

      end
    end
  end
end
