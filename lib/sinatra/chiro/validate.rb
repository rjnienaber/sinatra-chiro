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
          all_params = named_params + query_params + forms


          allowed_params = []
          given_params = []
          errors = []

          all_params.each do |object|
            unless all_given[object.options[:name].to_s] == nil
                errors << object.validate(all_given)
            end
            if !object.options[:optional]
              errors << "must include a #{object.options[:name].to_s} parameter" if all_given[object.options[:name].to_s] == nil
            end
            allowed_params << object.options[:name].to_s
          end

          all_given.each do |k, v|
            given_params << k.to_s
          end

          given_params.each do |param|
            errors << "#{param} is not a valid parameter" if !allowed_params.include?(param)
          end

          if !errors.compact.empty? then
            errors.compact.join('<br>')
          end

        end
      end
    end
  end
end