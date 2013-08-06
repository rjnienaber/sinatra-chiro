module Sinatra
  module Chiro
    module Parameters
      class FixnumValidator < Base
        def validate(given)
          "#{options[:name].to_s} parameter must be an integer" if  given[options[:name]] !~/^\s*\d+\s*$/
        end
      end
    end
  end
end
