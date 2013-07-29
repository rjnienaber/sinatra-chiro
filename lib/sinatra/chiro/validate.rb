module Sinatra
  module Chiro
    class MyValidator
      attr_reader :endpoints

      def initialize(endpoints)
        @endpoints = endpoints
      end

      def validate(params, env)

        require 'pp'

        _, url = env['sinatra.route'].split('/')
        errors = []
        @index = nil

        endpoints.map.with_index.to_a.each do |endpoint, index|    # gives each endpoint an index and iterates
          if url == endpoint.path.split('/')[1]                         # matches endpoint path to url
            @index = index                      # assigns @index the value of the endpoint with the appropriate path
          end
        end

        require 'time'

        my_params = params.dup
        my_params.delete('captures')
        my_params.delete('splat')
        all_given = my_params

        named_params = endpoints[@index].named_params
        query_params = endpoints[@index].query_params
        payload = endpoints[@index].forms
        all_params = named_params + query_params + payload      # prepares all_params array to validate all at once


        allowed_params = []
        given_params = []

        all_params.each do |hash|
          param = hash[:name]
          parameter = param.to_s

# all parameters validated here
          unless all_given[parameter] == nil
            if hash[:type] == String
              errors << "#{parameter} parameter must be a string of only letters" if all_given[parameter]!~/^[a-zA-Z]*$/
              errors << "#{parameter} parameter must not be empty" if all_given[parameter].empty?

            elsif hash[:type] == Fixnum
              errors << "#{parameter} parameter must be an integer" if all_given[parameter]!~/^\s*\d+\s*$/

            elsif hash[:type] == Float
              errors << "#{parameter} parameter must be a Float" if all_given[parameter]!~/^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/

            elsif hash[:type] == Array[String]
              errors << "#{parameter} parameter must be an Array of Strings" if !all_given[parameter].is_a? Array

            elsif hash[:type] == Date
             errors << "#{parameter} parameter must be a string in the format: yyyy-mm-dd" if all_given[parameter] !~ /^\d{4}-\d{2}-\d{2}$/
            begin
              Date.parse("#{all_given[parameter]}")
            rescue ArgumentError
              errors << "#{parameter} parameter invalid"
            end

            elsif hash[:type] == DateTime
            errors << "#{parameter} parameter must be a string in the format: yyyy-mm-ddThh:mm:ss" if all_given[parameter] !~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$/
            begin
              Time.parse("#{all_given[parameter]}")
            rescue ArgumentError
              errors << "#{parameter} parameter invalid"
            end

            elsif hash[:type] == Time
              errors << "#{parameter} parameter must be a string in the format: hh:mm:ss" if all_given[parameter] !~ /^\d{2}:\d{2}:\d{2}$/
              begin
                Time.parse("#{all_given[parameter]}")
              rescue ArgumentError
                errors << "#{parameter} parameter invalid"
              end

            elsif hash[:type] == :boolean
              errors << "#{parameter} parameter must be a boolean" unless (all_given[parameter]=="true" or all_given[parameter]=="false")
            end

            if hash[:type].is_a? Regexp
              errors << "#{parameter} parameter should match regex: #{hash[:type]}" if all_given[parameter] !~ hash[:type]
            end
          end

          if !hash[:optional]
            errors << "must include a #{parameter} parameter" if all_given[parameter] == nil
          end

          allowed_params << parameter
        end

        all_given.each do |k, v|
          given_params << k.to_s
        end

        given_params.each do|param|
          errors << "#{param} is not a valid parameter" if !allowed_params.include?(param)
        end

        if !errors.empty? then
          return errors.join('<br>')              # if there are errors return them!
        else
          return nil
        end

      end
    end
  end
end