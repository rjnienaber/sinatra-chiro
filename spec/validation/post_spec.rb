require 'spec_helper'
ru_file = File.dirname(__FILE__) + '/../example_apps/config.ru'
SERVER_APP = Rack::Builder.parse_file(ru_file).first

describe 'Server application' do
  def app
    SERVER_APP
  end

  context 'suceeds' do
    it 'when all parameters verified' do
      get '/form'
      last_response.should be_ok
      last_response.body.should == "<form action='form' method='post'>
        Enter a number: <input type='text' name='fixnum'><br>
        Enter a noun: <input type='text' name='string'><br>
        Enter a time: <input type='text' name='time'><br>
        Enter a boolean: <input type='text' name='boolean'>
       <br><input type='submit'></form>"
    end

    it 'when all parameters entered' do
      get '/form'
      last_response.should be_ok
      last_response.body.should == "<form action='form' method='post'>
        Enter a number: <input type='text' name='fixnum'><br>
        Enter a noun: <input type='text' name='string'><br>
        Enter a time: <input type='text' name='time'><br>
        Enter a boolean: <input type='text' name='boolean'>
       <br><input type='submit'></form>"
      post '/form', {:string => 'apple', :time => '12:00:00', :fixnum => '20', :boolean => 'true'}
      last_response.should be_ok
      last_response.body.should == "Is it true that 20 apples disappeared at 12:00pm yesterday?"
    end

  end


  context 'returns validation error' do
    it 'when string parameter left blank' do
      get '/form'
      last_response.should be_ok
      last_response.body.should == "<form action='form' method='post'>
        Enter a number: <input type='text' name='fixnum'><br>
        Enter a noun: <input type='text' name='string'><br>
        Enter a time: <input type='text' name='time'><br>
        Enter a boolean: <input type='text' name='boolean'>
       <br><input type='submit'></form>"
      post '/form', {:string => ''}
      last_response.should be_forbidden
      last_response.body.should == "string parameter must not be empty"
    end

    it 'when only string parameter entered' do
      get '/form'
      last_response.should be_ok
      last_response.body.should == "<form action='form' method='post'>
        Enter a number: <input type='text' name='fixnum'><br>
        Enter a noun: <input type='text' name='string'><br>
        Enter a time: <input type='text' name='time'><br>
        Enter a boolean: <input type='text' name='boolean'>
       <br><input type='submit'></form>"
      post '/form', {:string => 'apple', :time => '', :fixnum => '', :boolean => ''}
      last_response.body.should == "fixnum parameter must be a Float<br>boolean parameter must be a boolean<br>time parameter must be a string in the format: hh:mm:ss<br>time parameter invalid"
    end
  end
end

