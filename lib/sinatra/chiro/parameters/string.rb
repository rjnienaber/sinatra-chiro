module Sinatra
  module Chiro
    module Parameters
      class StringValidator < Base
        def validate(given)
          if given[name_display] !~/^[a-zA-Z]*$/
            "#{name_display} parameter must be a string of only letters"
          elsif given[name_display].empty?
            "#{name_display} parameter must not be empty"
          end
        end
      end
    end
  end
end

