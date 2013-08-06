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

        def description
          @options[:description]
        end

        def comment
          nil
        end

        def type_description
          @options[:type]
        end

        def optional
          @options[:optional]
        end
      end
    end
  end
end