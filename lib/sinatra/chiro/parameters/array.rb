require File.dirname(__FILE__) + '/base'

module Sinatra
  module Chiro
    module Parameters
      class ArrayValidator < Base
        def validate(given, hash)
          "#{hash[:name]} parameter must be an Array of Strings" if !given.is_a? Array
        end
      end
    end
  end
end

