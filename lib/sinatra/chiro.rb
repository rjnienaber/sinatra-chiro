require 'sinatra/chiro/endpoint'
require 'sinatra/chiro/middleware'

module Sinatra
  module Chiro
    @@documentation = []

    def endpoint(description)
      @params = []
      @query_strings = []
      yield
      @@documentation << Endpoint.new(description, @verb, @path, @params, @query_strings, @returns)
    end

    def param(name, type, description)
      @params << {name: name, type: type, description: description}
    end

    def query_string(name, type, description)
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