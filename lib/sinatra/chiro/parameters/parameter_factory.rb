module Sinatra
  module Chiro
    module Parameters
      class ParameterFactory
        def self.validator_from_type(options)
          validator = case options[:type].to_s
                        when 'String' then StringValidator
                        when 'Fixnum' then FixnumValidator
                        when 'Float' then FloatValidator
                        when 'Date' then DateValidator
                        when 'DateTime' then DateTimeValidator
                        when 'Time' then TimeValidator
                        when 'boolean' then BooleanValidator
                        when '[String]' then ArrayValidator
                        else
                          if options[:type].is_a? Regexp
                            RegexpValidator
                          end
                      end
          validator.new(options)
        end
      end
    end
  end
end

