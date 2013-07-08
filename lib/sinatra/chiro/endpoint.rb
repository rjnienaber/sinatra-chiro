class Endpoint
  attr_reader :description, :verb, :path, :named_params, :query_params, :returns

  def initialize(opts)
    @description = opts[:description]
    @verb = opts[:verb]
    @path = opts[:path]
    @named_params = opts[:named_params]
    @query_params = opts[:query_params]
    @perform_validation = opts[:perform_validation]
    @returns = opts[:returns]
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
     :returns => returns}.to_json
  end
end