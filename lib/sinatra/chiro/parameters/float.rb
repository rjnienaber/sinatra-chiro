module Sinatra
  module Chiro
    module Parameters
      class FloatValidator < Base
        def validate(given)
          "#{options[:name].to_s} parameter must be a Float" if  given[options[:name]]!~/^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/
        end
      end
    end
  end
end
