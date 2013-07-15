require 'spec_helper'
ru_file = File.dirname(__FILE__) + '/../example_apps/config.ru'
SERVER_APP = Rack::Builder.parse_file(ru_file).first

describe 'Server application' do
  def app
    SERVER_APP
  end

  it 'returns hello world' do
    get '/hi/Hello'
    last_response.should be_ok
    last_response.body.should == 'Hello world!'
  end
end

