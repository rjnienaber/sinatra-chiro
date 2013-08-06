module Sinatra
  module Chiro
    module Parameters
      class DateValidator < Base
        def validate(given)
          begin
            Date.parse("#{given}")
          rescue ArgumentError
            @err = true
          end
          if @err
            "#{options[:name].to_s} parameter invalid"
          elsif given[options[:name]] !~ /^\d{4}-\d{2}-\d{2}$/
            "#{options[:name].to_s} parameter must be a string in the format: yyyy-mm-dd"
          else
            nil
          end
        end

        def comment
          'Must be expressed according to ISO 8601 (ie. YYYY-MM-DD)'
        end
      end
    end
  end
end

