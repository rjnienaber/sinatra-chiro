module Sinatra
  module Chiro
    module Parameters
      class ParameterFactory
        def self.validator_from_type(options)
          type = options[:type]
          if type == String
            Sinatra::Chiro::Parameters::StringValidator.new(options)
          elsif type == Fixnum
            Sinatra::Chiro::Parameters::FixnumValidator.new(options)
          elsif type == Float
            Sinatra::Chiro::Parameters::FloatValidator.new(options)
          elsif type == :boolean
            Sinatra::Chiro::Parameters::BooleanValidator.new(options)
          elsif type == Float
            Sinatra::Chiro::Parameters::FloatValidator.new(options)
          elsif type.is_a? Regexp
            Sinatra::Chiro::Parameters::RegexpValidator.new(options)
          elsif type == Date
            Sinatra::Chiro::Parameters::DateValidator.new(options)
          elsif type == DateTime
            Sinatra::Chiro::Parameters::DateTimeValidator.new(options)
          elsif type == Time
            Sinatra::Chiro::Parameters::TimeValidator.new(options)
          elsif type == [String]
            Sinatra::Chiro::Parameters::ArrayValidator.new(options)
          end
        end
      end
    end
  end
end

