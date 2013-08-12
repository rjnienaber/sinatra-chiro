module Sinatra
  module Chiro
    module Parameters
      class FixnumValidator < Base
        def validate(given)
          "#{name_display} parameter must be an integer" if  given[name] !~/^\s*\d+\s*$/
        end
      end
    end
  end
end
