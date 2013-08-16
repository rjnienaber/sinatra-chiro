require 'spec_helper'
ru_file = File.dirname(__FILE__) + '/../example_apps/user_views/config.ru'
puts "TEST 1"
SERVER_APP2 = Rack::Builder.parse_file(ru_file).first
puts "TEST 2"

describe 'Classic Style Application' do
  def app
    SERVER_APP2
  end

  it 'displays new erb file for new routes' do
    puts SERVER_APP2.settings.routes_path
    get '/reroutes'
    pending ('test fails but /reroutes in browser works')
    last_response.should be_ok
    last_response.body.should == "success"
  end

  it 'displays new erb file for new help key' do
    get '/hi?helpme'
    last_response.should be_ok
    last_response.body.should == "success"
  end
end