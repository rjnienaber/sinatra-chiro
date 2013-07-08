class Endpoint
  attr_reader :description, :verb, :path, :params, :query_string, :returns

  def initialize(description, verb, path, params, query_string, returns)
    @description = description
    @verb = verb
    @path = path
    @params = params
    @query_string = query_string
    @returns = returns
  end

  def route
    "#{verb}: #{path}"
  end

  def to_json(*a)
    {:description => description,
     :verb => verb,
     :path => path,
     :params => params,
     :query_string => query_string,
     :returns => returns}.to_json
  end
end