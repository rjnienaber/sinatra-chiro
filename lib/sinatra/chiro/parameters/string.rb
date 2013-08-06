module Sinatra
  module Chiro
    module Parameters
      class StringValidator < Base
        def validate(given)
          if given[options[:name].to_s] !~/^[a-zA-Z]*$/
            "#{options[:name].to_s} parameter must be a string of only letters"
          elsif given[options[:name].to_s].empty?
            "#{options[:name].to_s} parameter must not be empty"
          end
        end
      end
    end
  end
end

