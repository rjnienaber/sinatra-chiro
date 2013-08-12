module Sinatra
  module Chiro
    module Parameters
      class DateValidator < Base
        def validate(given)
          begin
            Date.parse(given.to_s)

            if given[name] !~ /^\d{4}-\d{2}-\d{2}$/
              "#{name_display} parameter must be a string in the format: yyyy-mm-dd"
            end

          rescue ArgumentError
            "#{name_display} parameter invalid"
          end
        end

        def comment
          'Must be expressed according to ISO 8601 (ie. YYYY-MM-DD)'
        end
      end
    end
  end
end

