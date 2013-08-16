$:.unshift(File.dirname(__FILE__) + '/../lib/')

require 'rack/test'

#set :environment, :test

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end