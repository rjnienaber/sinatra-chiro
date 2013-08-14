require 'spec_helper'
ru_file = File.dirname(__FILE__) + '/../example_apps/user_views/config.ru'
SERVER_APP2 = Rack::Builder.parse_file(ru_file).first


p settings.erb_file

describe 'Classic Style Application' do
  def app
    SERVER_APP2
  end

  it 'displays new erb file for routes' do
    get '/routes'
    last_response.should be_ok
    last_response.body.should == "success"
  end
end