module Sinatra
  module Chiro
    module Parameters
      class FloatValidator
        def validate(given, hash)
          "#{hash[:name].to_s} parameter must be a Float" if given !~/^\s*[+-]?((\d+_?)*\d+(\.(\d+_?)*\d+)?|\.(\d+_?)*\d+)(\s*|([eE][+-]?(\d+_?)*\d+)\s*)$/
        end
      end
    end
  end
end
