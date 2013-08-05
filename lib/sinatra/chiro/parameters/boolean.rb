module Sinatra
  module Chiro
    module Parameters
      class BooleanValidator
        def validate(given, hash)
          if (given=="true" or given=="false")
            nil
          else
            "#{hash[:name].to_s} parameter must be a boolean"
          end
        end

        def comment(type)
          "Must be true or false"
        end
      end
    end
  end
end

