require File.dirname(__FILE__) + '/base'

module Sinatra
  module Chiro
    module Parameters
      class ArrayValidator < Base
        def validate(given)
          "#{options[:name]} parameter must be an Array of Strings" if ! given[options[:name]].is_a? Array
        end
      end
    end
  end
end

