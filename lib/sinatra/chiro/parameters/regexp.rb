module Sinatra
  module Chiro
    module Parameters
      class RegexpValidator < Base

        def validate(given)
          "#{name_display} parameter should match regexp: #{options[:type]}" if given[name] !~ options[:type]
        end

        def type_description
          super || "Regexp"
        end

        def comment
          "#{options[:comment]}"
        end

      end
    end
  end
end

