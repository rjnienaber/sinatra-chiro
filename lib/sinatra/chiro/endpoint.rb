class Endpoint
  attr_reader :description, :verb, :path, :named_params, :query_params, :payload, :returns

  def initialize(opts)
    @description = opts[:description]
    @verb = opts[:verb]
    @path = opts[:path]
    @named_params = opts[:named_params]
    @query_params = opts[:query_params]
    @perform_validation = opts[:perform_validation]
    @returns = opts[:returns]
    @payload = opts[:payload]
  end


  def route
    "#{verb}: #{path}"
  end

  def validate?
    @perform_validation
  end

  def to_json(*a)
    {:description => description,
     :verb => verb,
     :path => path,
     :named_params => named_params,
     :query_params => query_params,
     :payload => payload,
     :returns => returns,
     :opts => payload}.to_json
  end
end