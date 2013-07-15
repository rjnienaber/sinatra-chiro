require 'spec_helper'
ru_file = File.dirname(__FILE__) + '/../example_apps/config.ru'
SERVER_APP = Rack::Builder.parse_file(ru_file).first

describe 'Server application' do
  def app
    SERVER_APP
  end

  it 'returns hello world when all parameters except people are specified' do
    get '/hi?greeting=Hello&language=en&year=2013'
    last_response.should be_ok
    last_response.body.should == 'Hello world! Happy new year for 2013'
  end

  it 'returns hello "names" when names are specified' do
    get '/hi?greeting=Hello&language=en&year=2013&people[]=name1&people[]=name2'
    last_response.should be_ok
    last_response.body.should == 'Hello name1, name2! Happy new year for 2013'
  end

  it 'return validation error if language is omitted' do
    get '/hi?greeting=Hello&year=2013'
    #last_response.should be_ok
    last_response.body.should == "must include a language parameter"
  end

  it 'return validation error if invalid language' do
    get '/hi?greeting=Hello&year=2013&language=piglatin'
    #last_response.should be_ok
    last_response.body.should == "not a valid language"
  end

  it 'return validation error if extra parameter is included' do
    get '/hi?greeting=Hello&year=2013&language=en&extra=something'
    #last_response.should be_ok
    last_response.body.should == "extra is not a valid parameter"
  end

  it 'return validation error if people is a string' do
    get '/hi?greeting=Hello&year=2013&language=en&people=scott'
    #last_response.should be_ok
    last_response.body.should == "people parameter must be an Array"
  end

  it 'return validation error if greeting is an array' do
    get '/hi?greeting[]=Hello&year=2013&language=en'
    #last_response.should be_ok
    last_response.body.should == "greeting parameter must be a String"
  end

  it 'return validation error if year is a string' do
    get '/hi?greeting=Hello&year=word&language=en'
    #last_response.should be_ok
    last_response.body.should == "year must be a number"
  end
end

