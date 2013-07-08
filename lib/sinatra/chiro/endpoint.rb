class Endpoint
  attr_reader :description, :verb, :path, :named_params, :query_params, :returns

  def initialize(description, verb, path, params, query_string, returns)
    @description = description
    @verb = verb
    @path = path
    @named_params = params
    @query_params = query_string
    @returns = returns
  end

  def route
    "#{verb}: #{path}"
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