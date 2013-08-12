module Sinatra
  module Chiro
    module Parameters
      class FloatValidator < Base
        def validate(given)
          "#{name_display} parameter must be a Float" if given[name]!~/^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/
        end
      end
    end
  end
end
