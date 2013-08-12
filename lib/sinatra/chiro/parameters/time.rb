module Sinatra
  module Chiro
    module Parameters
      class TimeValidator < Base
        def validate(given)
          begin
            Time.parse(given.to_s)

            if given[name] !~ /^\d{2}:\d{2}:\d{2}$/
              "#{name_display} parameter must be a string in the format: hh:mm:ss"
            end
          rescue ArgumentError
            "#{name_display} parameter invalid"
          end
        end

        def comment
          'Must be expressed according to ISO 8601 (ie. hh:mm:ss)'
        end
      end
    end
  end
end

