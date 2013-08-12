class Endpoint
  attr_reader :appname, :description, :verb, :path, :named_params, :query_params, :forms, :possible_errors, :response, :title

  def initialize(opts)
    @appname = opts[:appname]
    @description = opts[:description]
    @title = opts[:title]
    @verb = opts[:verb]
    @path = opts[:path]
    @named_params = opts[:named_params]
    @query_params = opts[:query_params]
    @perform_validation = opts[:perform_validation]
    @response = opts[:response]
    @forms = opts[:forms]
    @possible_errors = opts[:possible_errors]
  end


  def route
    "#{verb}: #{path}"
  end

  def validate?
    @perform_validation
  end

  def to_json(*a)
    {:title => title,
     :description => description,
     :verb => verb,
     :path => path,
     :named_params => named_params,
     :query_params => query_params,
     :forms => forms,
     :possible_errors => possible_errors,
     :response => response,
     }.to_json
  end
end