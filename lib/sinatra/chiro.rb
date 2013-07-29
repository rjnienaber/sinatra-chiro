require 'sinatra/chiro/endpoint'
require 'sinatra/chiro/document'
require 'sinatra/chiro/validate'

module Sinatra

  class Base
    #we monkey patch here because at this point we know the name of the route
    alias_method :old_route_eval, :route_eval
    def route_eval
      if params.has_key? "help"
        help = Sinatra::Chiro::Documentation.new.show(self, env)
        status 200
        throw :halt, "#{help}"
      else
        error = Sinatra::Chiro::MyValidator.new.validate(self, params, env)
        if error == "not found"
          status 404
          throw :halt, "Path not found"
        elsif error!= nil
          status 403
          throw :halt, "#{error}"
        end
      end

      old_route_eval { yield }
    end
  end

  module Chiro
    attr_reader :documentation

    def endpoint(description=nil, opts={})
      @documentation ||= []
      opts[:description] ||= description
      opts[:perform_validation] ||= true
      @named_params = []
      @query_params = []
      @forms = []

      yield

      opts[:verb] = @verb || :GET
      opts[:named_params] = @named_params
      opts[:query_params] = @query_params
      opts[:forms] = @forms
      opts[:returns] = @returns
      opts[:path] = @path
      @documentation << Endpoint.new(opts)
    end

    def named_param(name, description, opts={})
      opts[:optional] = false
      Chiro.remove_unknown_param_keys(opts)
      Chiro.set_param_defaults(opts)
      @named_params << {:name => name, :description => description}.merge(opts)
    end

    def form(name, description, opts={})
      opts[:optional] = true
      Chiro.remove_unknown_param_keys(opts)
      Chiro.set_param_defaults(opts)
      @forms << {:name => name, :description => description}.merge(opts)
    end

    def query_param(name, description, opts={})
      Chiro.remove_unknown_param_keys(opts)
      Chiro.set_param_defaults(opts)
      @query_params << {:name => name, :description => description}.merge(opts)
    end

    def get(path, opts = {}, &block)
      @path = path
      @verb = :GET
      super
    end

    def post(path, opts = {}, &bk)
      @path = path
      @verb = :POST
      super
    end

    def returns(result)
      @returns = result
    end

    def self.registered(app)
      app.get '/routes' do
        app.documentation.map { |d| d.route }.to_json
      end
    end

    private
    def self.remove_unknown_param_keys(opts)
      known_options = [:default, :type, :optional]
      opts.delete_if { |k| !k.is_a?(Symbol) || !known_options.include?(k)}
    end

    def self.set_param_defaults(opts)
      opts[:type] ||= String
      opts[:optional] ||= true if opts[:optional].nil?
    end

  end

  register Sinatra::Chiro
end