module Sinatra
  class Base
    #we monkey patch here because at this point we know the name of the route
    alias_method :old_route_eval, :route_eval
    def route_eval
      if params.has_key? "help"
        status 200
        throw :halt, "#{erb(:help, {}, :endpoint => self.class.documentation.document(env)) }"
      else
        if self.class.respond_to?(:validator)
          error = self.class.validator.validate(params, env)
          if error == "not found"
            status 404
            throw :halt, "Path not found"
          elsif error!= nil
            status 403
            throw :halt, "#{error}"
          end
        end
      end

      old_route_eval { yield }
    end
  end
end