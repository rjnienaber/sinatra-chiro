module Sinatra
  module Chiro
    class Middleware

      require 'time'

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
          if k == 'interests'
            errors << "interests parameter must be an Array" if !v.is_a? Array
          else
            errors << "#{k} parameter must be a String" if v.is_a? Array
          end
        end

        ['interests', 'birthdate', 'name', 'height', 'deathtime'].each do |parameter|
          errors << "must include a #{parameter} parameter" if query_hash[parameter] == nil
        end

        sex = query_hash['gender']
        errors << "not a valid gender" unless (sex ==nil or sex=="male" or sex=="female") if sex !=nil

        height = query_hash['height']
        errors << "height must be a float" if (height !~ /^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/) unless height ==nil
        errors << "height must be positive" if (height.to_i < 0) unless height ==nil
        errors << "height must be less than 3" if (height.to_i >= 3.0) unless height ==nil


        if query_hash['birthdate'] != nil
          begin
            Date.parse("#{query_hash['birthdate']}")
          rescue ArgumentError
            errors << "invalid date of birth"
          end
        end

        if query_hash['deathtime'] != nil
          begin
            Time.parse("#{query_hash['deathtime']}")
          rescue ArgumentError
            errors << "invalid time/date of death"
          end
        end

        query_hash.each do|k,v|
          errors << "#{k} is not a valid parameter" if (k!="gender" and k!="interests" and k!="name" and k!="birthdate" and k!="height" and k!="deathtime")
        end



        [403, {'Content-Type' => 'text/plain'}, [errors.join("\n")]] if !errors.empty?

      end
    end
  end
end
