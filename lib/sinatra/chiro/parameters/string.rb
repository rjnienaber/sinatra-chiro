module Sinatra
  module Chiro
    module Parameters
      class StringValidator
        def validate(given, hash)
          if given !~/^[a-zA-Z]*$/
            "#{hash[:name].to_s} parameter must be a string of only letters"
          elsif given.empty?
            "#{hash[:name].to_s} parameter must not be empty"
          end
        end
      end
    end
  end
end

