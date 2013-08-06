module Sinatra
  module Chiro
    module Parameters
      class BooleanValidator < Base
        def validate(given)
          if (given[options[:name]]=="true" or given[options[:name]]=="false")
            nil
          else
            "#{options[:name].to_s} parameter must be true or false"
          end
        end

        def comment(type)
          "Must be true or false"
        end
      end
    end
  end
end

