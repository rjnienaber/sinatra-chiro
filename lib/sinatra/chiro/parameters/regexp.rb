module Sinatra
  module Chiro
    module Parameters
      class RegexpValidator < Base

        def validate(given)
          "#{options[:name].to_s} parameter should match regexp: #{options[:type]}" if given[options[:name]] !~ options[:type]
        end

        def type_description
          "Regexp"
        end

        def comment(type)
          "Must match regular expression: #{type}"
        end

      end
    end
  end
end

