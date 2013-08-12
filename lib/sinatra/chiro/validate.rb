require 'time'

module Sinatra
  module Chiro
    class Validation
      attr_reader :endpoints

      def initialize(endpoints)
        @endpoints = endpoints
      end

      def validate(params, env)
        _, path = env['sinatra.route'].split

        endpoint = endpoints.select { |d| d.path == path }.flatten.first
        return if endpoint.nil?

        all_given = params.dup
        all_given.delete('captures')
        all_given.delete('splat')

        all_params = endpoint.named_params + endpoint.query_params + endpoint.forms

        allowed_params = []
        errors = []

        all_params.each do |parameter|
          unless all_given[parameter.name_display].nil?
            errors << parameter.validate(all_given)
          end
          if !parameter.optional
            errors << "must include a #{parameter.name_display} parameter" if all_given[parameter.name_display].nil?
          end
          allowed_params << parameter.name_display
        end

        all_given.map { |k, _| k.to_s}.each do |param|
          errors << "#{param} is not a valid parameter" if !allowed_params.include?(param)
        end

        if !errors.compact.empty? then
          JSON.dump ({:validation_errors => errors.compact})
        end
      end
    end
  end
end