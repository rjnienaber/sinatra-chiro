module Sinatra
  module Chiro
    module Parameters
      class FixnumValidator
        def validate(given, hash)
          "#{hash[:name].to_s} parameter must be an integer" if given !~/^\s*\d+\s*$/
        end
      end
    end
  end
end
