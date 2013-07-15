require 'spec_helper'
ru_file = File.dirname(__FILE__) + '/../example_apps/config.ru'
SERVER_APP = Rack::Builder.parse_file(ru_file).first

describe 'Server application' do
  def app
    SERVER_APP
  end

  context "succeeds" do
    it 'when all parameters except gender are specified' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=scott&birthdate=1993-07-05&height=1.8&interests[]=physics&interests[]=sports'
      last_response.should be_ok
      last_response.body.should == 'Scott was born on 05 Jul 1993. It was interested in physics, sports, and was 1.8m tall before it died, at 10:30am on Tue 16 Jul 2013.'
    end

    it 'when interests are specified' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics'
      last_response.should be_ok
      last_response.body.should == 'Scott was born on 05 Jul 1993. He was interested in physics, and was 1.8m tall before he died, at 10:30am on Tue 16 Jul 2013.'
    end
  end

  context 'returns validation error' do
    it 'if extra parameter is included' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics&extra=value'
      last_response.should be_forbidden
      last_response.body.should == "extra is not a valid parameter"
    end

    it 'if missing parameter' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&height=1.8&interests[]=physics&gender=male'
      last_response.should be_forbidden
      last_response.body.should == "must include a birthdate parameter"
    end

    it 'if multiple missing parameters' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&interests[]=physics&gender=male'
      last_response.should be_forbidden
      last_response.body.should == "must include a birthdate parameter\nmust include a height parameter"
    end

    it 'if invalid gender' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=robot&birthdate=1993-07-05&height=1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "not a valid gender"
    end

    it ' if interests is a string' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests=physics'
      last_response.should be_forbidden
      last_response.body.should == "interests parameter must be an Array"
    end

    it 'if name is an array' do
      get '/bio?deathtime=2013-07-16T10:30:00&name[]=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "name parameter must be a String"
    end

    it 'if birthdate is invalid' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-33&height=1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "invalid date of birth"
    end

    it 'if deathdate is invalid' do
      get '/bio?deathtime=2013-13-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "invalid time/date of death"
    end

    it 'if deathtime is invalid' do
      get '/bio?deathtime=2013-07-16T10:63:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "invalid time/date of death"
    end

    it 'if height is too large' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=18&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "height must be less than 3"
    end

    it 'if height is a negative' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=-1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "height must be positive"
    end

    it 'if height is not a float' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=word&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "height must be a float"
    end
  end
end

