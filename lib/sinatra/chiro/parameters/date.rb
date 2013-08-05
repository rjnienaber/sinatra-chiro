module Sinatra
  module Chiro
    module Parameters
      class DateValidator
        def validate(given, hash)
          begin
            Date.parse("#{given}")
          rescue ArgumentError
            @err = true
          end
          if @err
            "#{hash[:name].to_s} parameter invalid"
          elsif given !~ /^\d{4}-\d{2}-\d{2}$/
            "#{hash[:name].to_s} parameter must be a string in the format: yyyy-mm-dd"
          else
            nil
          end
        end

        def comment(type)
          'Must be expressed according to ISO 8601 (ie. YYYY-MM-DD)'
        end
      end
    end
  end
end

