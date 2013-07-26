require 'sinatra/chiro/endpoint'
require 'sinatra/chiro/middleware'
require 'sinatra/chiro/validate'

module Sinatra
  module Chiro
    @@documentation = []

    def endpoint(description=nil, opts={})
      opts[:description] ||= description
      opts[:perform_validation] ||= true
      @named_params = []
      @query_params = []
      @payload = []

      yield

      opts[:verb] = @verb || :GET
      opts[:named_params] = @named_params
      opts[:query_params] = @query_params
      opts[:payload] = @payload
      opts[:returns] = @returns
      opts[:path] = @path
      @@documentation << Endpoint.new(opts)
    end

    def named_param(name, description, opts={})
      opts[:optional] = false
      Chiro.remove_unknown_param_keys(opts)
      Chiro.set_param_defaults(opts)
      @named_params << {:name => name, :description => description}.merge(opts)
    end

    def payload(name, description, opts={})
      opts[:optional] = true
      Chiro.remove_unknown_param_keys(opts)
      Chiro.set_param_defaults(opts)
      @payload << {:name => name, :description => description}.merge(opts)
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
        @@documentation.map { |d| d.route }.to_json
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