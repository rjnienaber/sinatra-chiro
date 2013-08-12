require 'sinatra/chiro/endpoint'
require 'sinatra/chiro/document'
require 'sinatra/chiro/validate'
require 'sinatra/chiro/monkey_patch'
Dir[File.dirname(__FILE__) + '/chiro/parameters/*.rb'].sort.each { |f| require f}

CHIRO_APPS = []
module Sinatra
  module Chiro
    def endpoints
      @endpoints ||= []
    end

    def validator
      @validator ||= Validation.new(endpoints)
    end

    def documentation
      @documentation ||= Documentation.new(endpoints)
    end

    def app_description(description)
      @app_description = description
    end

    def endpoint(title=nil, description=nil, opts={})
      opts[:title] ||= title
      opts[:description] ||= description
      opts[:perform_validation] ||= true
      @named_params = []
      @query_params = []
      @forms = []
      @possible_errors = []
      @response = nil
      @appname = @app_description || self.name

      yield

      opts[:verb] = @verb || :GET
      opts[:named_params] = @named_params
      opts[:query_params] = @query_params
      opts[:forms] = @forms
      opts[:possible_errors] = @possible_errors
      opts[:response] = @response
      opts[:path] = @path
      opts[:appname] = @appname
      endpoints << Endpoint.new(opts)
    end

    def named_param(name, description, opts={})
      opts.merge!(:name => name, :description => description, :optional => false)
      Chiro.remove_unknown_param_keys(opts)
      Chiro.set_param_defaults(opts)
      @named_params << Parameters::ParameterFactory.validator_from_type(opts)
    end

    def form(name, description, opts={})
      opts.merge!(:name => name, :description => description)
      Chiro.remove_unknown_param_keys(opts)
      Chiro.set_param_defaults(opts)
      @forms << Parameters::ParameterFactory.validator_from_type(opts)
    end

    def query_param(name, description, opts={})
      opts.merge!(:name => name, :description => description)
      Chiro.set_param_defaults(opts)
      @query_params << Parameters::ParameterFactory.validator_from_type(opts)
    end

    def possible_error(name, code, description)
      @possible_errors << {:name => name, :code => code, :description => description}
    end

    def get(path, opts = {}, &block)
      @path = path
      @verb = :GET
      super
    end

    def post(path, opts = {}, &block)
      @path = path
      @verb = :POST
      super
    end

    def response(result)
      @response = result
    end

    def self.registered(app)
      CHIRO_APPS << app
      app.get '/routes' do
        routes = CHIRO_APPS.select { |a| a.respond_to?(:documentation) }.map { |a| a.documentation.routes }
        erb(:help, {}, :endpoint => routes)
      end
    end

    private
    def self.remove_unknown_param_keys(opts)
      known_options = [:name, :description, :default, :type, :optional, :validator, :comment, :type_description]
      opts.delete_if { |k| !k.is_a?(Symbol) || !known_options.include?(k)}
    end

    def self.set_param_defaults(opts)
      opts[:type] ||= String
      opts[:optional] ||= true if opts[:optional].nil?
    end

  end

  register Sinatra::Chiro
end
