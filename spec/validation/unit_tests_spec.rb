require 'spec_helper'
ru_file = File.dirname(__FILE__) + '/../example_apps/config.ru'
SERVER_APP = Rack::Builder.parse_file(ru_file).first

describe 'Other Application' do
  def app
    SERVER_APP
  end
  it 'greets a user using other app' do
    get '/hi' do
      last_response.should be_ok
      last_response.body.should == "Hello World!"
    end
  end
end

describe 'Other Application' do
  def app
    SERVER_APP
  end
  it 'greets a user using classic app' do
    get '/hi' do
      last_response.should be_ok
      last_response.body.should == "Hello World!"
    end
  end
end

describe 'Server application' do
  def app
    SERVER_APP
  end

  context 'succeeds' do
    it 'when string named parameter entered correctly' do
      get 'test/named/string/word'
      last_response.should be_ok
      last_response.body.should == 'Valid'
    end
    #tests named parameter validation

    it 'when fixnum query string parameter entered correctly' do
      get 'test/query?fixnum=12'
      last_response.should be_ok
      last_response.body.should == 'Valid'
    end
    #tests query string parameter validation

    it 'when date form parameter entered correctly' do
      post 'test/form/date', {:date => '1234-12-12'}
      last_response.should be_ok
      last_response.body.should == "Valid"
    end
    #tests form parameter validation

    it 'when named parameter repeated in query string' do
      get 'test/named/string/word?string=other'
      last_response.should be_ok
      last_response.body.should == 'Valid'
    end
    #tests to ensure repeated parameters in query string are ignored

    it 'when multiple query string parameters entered correctly' do
      get 'test/query?fixnum=12&string=hello&float=1.5&date=1999-12-12&time=12:33:11&datetime=1223-12-12T12:00:00&boolean=false&array[]=hello&array[]=howdy&gender=male'
      last_response.should be_ok
      last_response.body.should == 'Valid'
    end
    #tests validation of parameter types: string, float, time, date, datetime, fixnum, array, boolean

    it 'when regexp form parameter entered correctly' do
      post 'test/form/gender', {:gender => 'male'}
      last_response.should be_ok
      last_response.body.should == "Valid"
    end
    #tests validation of parameter type regexp
  end


  context 'returns validation error' do

    it 'if extra parameter is included' do
      get '/test/query?extra=value'
      last_response.should be_forbidden
      last_response.body.should == '{"validation_errors":["extra is not a valid parameter"]}'
    end

    it 'if multiple validation errors' do
      get '/test/query?gender=mangirl&coding=banter'
      last_response.should be_forbidden
      last_response.body.should == '{"validation_errors":["gender parameter should match regexp: (?-mix:^male$|^female$)","coding is not a valid parameter"]}'
    end

    it 'when path entered incorrectly' do
      get '/test//beans'
      last_response.should be_not_found
    end

    it 'if invalid regexp' do
      post '/test/form/gender', {:gender => 'robot'}
      last_response.should be_forbidden
      last_response.body.should == '{"validation_errors":["gender parameter should match regexp: (?-mix:^male$|^female$)"]}'
    end

    it 'if string named parameter is invalid' do
      get '/test/named/string/45'
      last_response.should be_forbidden
      last_response.body.should == '{"validation_errors":["string parameter must be a string of only letters"]}'
    end

    it 'if date in wrong format' do
      get '/test/named/date/1233-12-12T12:00:00'
      last_response.should be_forbidden
      last_response.body.should == '{"validation_errors":["date parameter must be a string in the format: yyyy-mm-dd"]}'
    end

    it 'if datetime in wrong format' do
      get '/test/query?datetime[]=1233-12-12T12:00:00'
      last_response.should be_forbidden
      last_response.body.should == '{"validation_errors":["datetime parameter must be a string in the format: yyyy-mm-ddThh:mm:ss"]}'
    end

    it 'if time entered in correct format but invalid' do
      get '/test/query?time=13:12:78'
      last_response.should be_forbidden
      last_response.body.should == '{"validation_errors":["time parameter invalid"]}'
    end

    it 'if float parameter invalid' do
      post '/test/form/float', {:float => 'balloon'}
      last_response.should be_forbidden
      last_response.body.should == '{"validation_errors":["float parameter must be a Float"]}'
    end

    it 'when boolean is neither true or false' do
      post '/test/form/boolean', {:boolean => 'untrue'}
      last_response.should be_forbidden
      last_response.body.should == '{"validation_errors":["boolean parameter must be true or false"]}'
    end

    it 'when extra post parameter given' do
      post '/test/form/string', {:string => 'word', :unlucky => 13}
      last_response.should be_forbidden
      last_response.body.should == '{"validation_errors":["unlucky is not a valid parameter"]}'
    end

    it 'when form parameter missing' do
      get '/test/form/fixnum'
      last_response.should be_not_found
    end
  end
end

