module Sinatra
  class Base
    #we monkey patch here because at this point we know the name of the route
    alias_method :old_route_eval, :route_eval
    def route_eval
      show_help if params.has_key? "help"
      validate_parameters if self.class.respond_to?(:validator)

      old_route_eval { yield }
    end

    def validate_parameters
      error = self.class.validator.validate(params, env)
      if error == "not found"
        status 404
        throw :halt, "Path not found"
      elsif error!= nil
        status 403
        throw :halt, "#{error}"
      end
    end

    def show_help
      if self.class.respond_to?(:validator)
        status 200
        throw :halt, "#{erb(:help, {}, :endpoint => self.class.documentation.document(env)) }"
      end
    end
  end
end

