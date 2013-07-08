require 'sinatra/chiro/endpoint'
require 'sinatra/chiro/middleware'

module Sinatra
  module Chiro
    @@documentation = []

    def endpoint(description=nil)
      @named_params = []
      @query_strings = []
      yield
      @@documentation << Endpoint.new(description, @verb, @path, @named_params, @query_strings, @returns)
    end

    def named_param(name, type, description)
      @named_params << {name: name, type: type, description: description}
    end

    def query_param(name, type, description)
      @query_strings << {name: name, type: type, description: description}
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
  end

  register Sinatra::Chiro
end