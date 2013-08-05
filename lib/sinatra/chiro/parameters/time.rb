module Sinatra
  module Chiro
    module Parameters
      class TimeValidator
        def validate(given, hash)
          begin
            Time.parse("#{given}")
          rescue ArgumentError
            @err = true
          end
          if @err
            "#{hash[:name].to_s} parameter invalid"
          elsif given !~ /^\d{2}:\d{2}:\d{2}$/
            "#{hash[:name].to_s} parameter must be a string in the format: hh:mm:ss"
          else
            nil
          end
        end

        def comment(type)
          'Must be expressed according to ISO 8601 (ie. hh:mm:ss)'
        end
      end
    end
  end
end

