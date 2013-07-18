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


        require 'pp'
        query_params = @documentation[0].query_params
        query_string = env['QUERY_STRING']
        query_hash = Rack::Utils.parse_nested_query("#{query_string}")
        errors = []

        allowed_params = []
        given_params = []
        query_hash.each do |k, v|
          given_params << k.to_sym
        end


        query_params.each do |hash|
          param = hash[:name]
          parameter = param.to_s
          unless query_hash[parameter] == nil
            if hash[:type] == String
              errors << "#{parameter} parameter must be a string of only letters" if query_hash[parameter]!~/^[a-zA-Z]*$/

            elsif hash[:type] == Fixnum
              errors << "#{parameter} parameter must be an integer" if query_hash[parameter]!~/^\s*\d+\s*$/

            elsif hash[:type] == Float
              errors << "#{parameter} parameter must be a Float" if query_hash[parameter]!~/^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/

            elsif hash[:type] == Array[String]
              errors << "#{parameter} parameter must be an Array of Strings" if !query_hash[parameter].is_a? Array

            elsif hash[:type] == Date
              errors << "#{parameter} parameter must be a string in the format: yyyy-mm-dd" if query_hash[parameter] !~ /^\d{4}-\d{2}-\d{2}$/
              begin
                Date.parse("#{query_hash[parameter]}")
              rescue ArgumentError
                errors << "#{parameter} parameter must be a string in the format: yyyy-mm-dd"
              end

            elsif hash[:type] == DateTime
              errors << "#{parameter} parameter must be a string in the format: yyyy-mm-ddThh:mm:ss" if query_hash[parameter] !~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$/
              begin
                Time.parse("#{query_hash[parameter]}")
              rescue ArgumentError
                errors << "#{parameter} parameter must be a string in the format: yyyy-mm-ddThh:mm:ss"
              end

            elsif hash[:type] == :boolean
              errors << "#{parameter} parameter must be a boolean" unless (query_hash[parameter]=="true" or query_hash[parameter]=="false")
            end

            if hash[:type].is_a? Regexp
              errors << "#{parameter} parameter should match regex: #{hash[:type]}" if query_hash[parameter] !~ hash[:type]
            end
          end

          allowed_params << param

          if !hash[:optional]
            errors << "must include a #{parameter} parameter" if query_hash[parameter] == nil
          end
        end

        given_params.each do|param|
          parameter = param.to_s
          errors << "#{parameter} is not a valid parameter" if !allowed_params.include?(param)
        end

        [403, {'Content-Type' => 'text/plain'}, [errors.join("\n")]] if !errors.empty?

      end
    end
  end
end
