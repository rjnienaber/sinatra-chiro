require 'time'

module Sinatra
  module Chiro
    class Validation
      attr_reader :endpoints

      def initialize(endpoints)
        @endpoints = endpoints
      end

      def validate(params, env)
        params.respond_to?('merge')
        _, path = env['sinatra.route'].split

        endpoint = endpoints.select do |d|
          d.path == path
        end.flatten.first


        all_given = params.dup
        all_given.delete('captures')
        all_given.delete('splat')

        if !endpoint.nil?
          named_params = endpoint.named_params
          query_params = endpoint.query_params
          forms = endpoint.forms
          all_params = named_params + query_params + forms # prepares all_params array to validate all at once


          allowed_params = []
          given_params = []
          errors = []

          all_params.each do |hash|
            validator = hash[:validator]
            unless all_given[hash[:name].to_s] == nil
                errors << validator.validate(all_given[hash[:name].to_s], hash)
            end
            if !hash[:optional]
              errors << "must include a #{hash[:name].to_s} parameter" if all_given[hash[:name].to_s] == nil
            end
            allowed_params << hash[:name].to_s
          end

          all_given.each do |k, v|
            given_params << k.to_s
          end

          given_params.each do |param|
            errors << "#{param} is not a valid parameter" if !allowed_params.include?(param)
          end


          if !errors.compact.empty? then
            errors.compact.join('<br>') # if there are errors return them!
          end

        end
      end
    end
  end
end
