module Sinatra
  module Chiro
    module Parameters
      class Base
        attr_reader :options
        def initialize(opts={})
          @options = opts
        end

        def name
          @options[:name]
        end

        def name_display
          @options[:name].to_s
        end

        def description
          @options[:description]
        end

        def comment
          nil
        end

        def type_description
          @options[:type_description] || @options[:type]
        end

        def type
          @options[:type]
        end

        def default
          @options[:default]
        end

        def optional
          @options[:optional]
        end
      end
    end
  end
end