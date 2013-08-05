module Sinatra
  module Chiro
    module Parameters
      class ParameterFactory
        def self.validator_from_type(type)
          if type == String
            Sinatra::Chiro::Parameters::StringValidator.new
          elsif type == Fixnum
            Sinatra::Chiro::Parameters::FixnumValidator.new
          elsif type == Float
            Sinatra::Chiro::Parameters::FloatValidator.new
          elsif type == :boolean
            Sinatra::Chiro::Parameters::BooleanValidator.new
          elsif type == Float
            Sinatra::Chiro::Parameters::FloatValidator.new
          elsif type.is_a? Regexp
            Sinatra::Chiro::Parameters::RegexpValidator.new
          elsif type == Date
            Sinatra::Chiro::Parameters::DateValidator.new
          elsif type == DateTime
            Sinatra::Chiro::Parameters::DateTimeValidator.new
          elsif type == Time
            Sinatra::Chiro::Parameters::TimeValidator.new
          elsif type == [String]
            Sinatra::Chiro::Parameters::ArrayValidator.new
          end
        end

        def self.commenter_from_type(type)
          if type == :boolean
            Sinatra::Chiro::Parameters::BooleanValidator.new
          elsif type.is_a? Regexp
            Sinatra::Chiro::Parameters::RegexpValidator.new
          elsif type == Date
            Sinatra::Chiro::Parameters::DateValidator.new
          elsif type == DateTime
            Sinatra::Chiro::Parameters::DateTimeValidator.new
          elsif type == Time
            Sinatra::Chiro::Parameters::TimeValidator.new
          end
        end
      end
    end
  end
end

