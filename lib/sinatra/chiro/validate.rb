require 'time'

module Sinatra
  module Chiro
    class Validation
      attr_reader :endpoints

      def initialize(endpoints)
        @endpoints = endpoints
      end

      def validate(params, env)
        path_array = env['sinatra.route'].split('/')[1..-1]

        endpoint = endpoints.select { |d| d.path.split('/')[1..-1] == path_array }.flatten.first


        my_params = params.dup
        my_params.delete('captures')
        my_params.delete('splat')
        all_given = my_params

        named_params = endpoint.named_params
        query_params = endpoint.query_params
        payload = endpoint.forms
        all_params = named_params + query_params + payload # prepares all_params array to validate all at once


        allowed_params = []
        given_params = []
        errors = []

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
              if all_given[parameter] !~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$/
                errors << "#{parameter} parameter must be a string in the format: yyyy-mm-ddThh:mm:ss"
              else
                begin
                  Time.parse("#{all_given[parameter]}")
                rescue ArgumentError
                  errors << "#{parameter} parameter invalid"
                end
              end

            elsif hash[:type] == Time
              if all_given[parameter] !~ /^\d{2}:\d{2}:\d{2}$/
                errors << "#{parameter} parameter must be a string in the format: hh:mm:ss"
              else
                begin
                  Time.parse("#{all_given[parameter]}")
                rescue ArgumentError
                  errors << "#{parameter} parameter invalid"
                end
              end

            elsif hash[:type] == :boolean
              errors << "#{parameter} parameter must be a boolean" unless (all_given[parameter]=="true" or all_given[parameter]=="false")
            end

            if hash[:type].is_a? Regexp
              errors << "#{parameter} parameter should match regexp: #{hash[:type]}" if all_given[parameter] !~ hash[:type]
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

        given_params.each do |param|
          errors << "#{param} is not a valid parameter" if !allowed_params.include?(param)
        end

        if !errors.empty? then
          errors.join('<br>') # if there are errors return them!
        end
      end
    end
  end
end