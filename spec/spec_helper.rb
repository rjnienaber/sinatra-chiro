$:.unshift(File.dirname(__FILE__) + '/../lib/')

require 'sinatra/base'
require 'sinatra/chiro'
require 'sinatra/reloader'
require 'rack/test'

require 'example_apps/server'

#set :environment, :test

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end