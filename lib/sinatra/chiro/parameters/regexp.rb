module Sinatra
  module Chiro
    module Parameters
      class RegexpValidator
        def validate(given, hash)
          "#{hash[:name].to_s} parameter should match regexp: #{hash[:type]}" if given !~ hash[:type]
        end

        def type_description
          'Regexp'
        end

        def comment(type)
          "Must match regular expression: #{type}"
        end

      end
    end
  end
end

