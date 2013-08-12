module Sinatra
  module Chiro
    module Parameters
      class BooleanValidator < Base
        def validate(given)
          if given[name] != "true" && given[name] != "false"
            "#{name_display} parameter must be true or false"
          end
        end

        def comment
          "Must be true or false"
        end
      end
    end
  end
end

