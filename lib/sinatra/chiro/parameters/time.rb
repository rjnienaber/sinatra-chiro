module Sinatra
  module Chiro
    module Parameters
      class TimeValidator < Base
        def validate(given)
          @err=false
          begin
            Time.parse("#{given}")
          rescue ArgumentError
            @err = true
          end
          if @err
            "#{options[:name].to_s} parameter invalid"
          elsif given[options[:name]] !~ /^\d{2}:\d{2}:\d{2}$/
            "#{options[:name].to_s} parameter must be a string in the format: hh:mm:ss"
          else
            nil
          end
        end

        def comment
          'Must be expressed according to ISO 8601 (ie. hh:mm:ss)'
        end
      end
    end
  end
end

