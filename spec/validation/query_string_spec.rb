require 'spec_helper'
ru_file = File.dirname(__FILE__) + '/../example_apps/config.ru'
SERVER_APP = Rack::Builder.parse_file(ru_file).first

describe 'Server application' do
  def app
    SERVER_APP
  end

  context "succeeds" do
    it 'when all parameters except gender and popular are specified' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=scott&birthdate=1993-07-05&height=1.8&interests[]=physics&interests[]=sports&friends=3'
      last_response.should be_ok
      last_response.body.should == "Scott was born on 05 Jul 1993. It was interested in physics, sports, and was 1.8m tall. It died at 10:30am on Tue 16 Jul 2013, to the indifference of its 3friends and family."
    end

    it 'when interests are specified' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics&friends=3'
      last_response.should be_ok
      last_response.body.should == "Scott was born on 05 Jul 1993. He was interested in physics, and was 1.8m tall. He died at 10:30am on Tue 16 Jul 2013, to the indifference of his 3friends and family."
    end

    it 'when all parameters are specified' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics&popular=false&friends=3'
      last_response.should be_ok
      last_response.body.should == "Scott was born on 05 Jul 1993. He was interested in physics, and was 1.8m tall. He died at 10:30am on Tue 16 Jul 2013, to the relief of his 3friends and family."
    end

    it 'if height is a negative' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=-1.8&interests[]=physics'
      last_response.should be_ok
      last_response.body.should == "Scott was born on 05 Jul 1993. He was interested in physics, and was -1.8m tall. He died at 10:30am on Tue 16 Jul 2013, to the indifference of his friends and family."
    end
  end

  context 'returns validation error' do
    it 'if extra parameter is included' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics&extra=value'
      last_response.should be_forbidden
      last_response.body.should == "extra is not a valid parameter"
    end

    ##
    it 'if missing parameter' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&height=1.8&interests[]=physics&gender=male'
      last_response.should be_forbidden
      last_response.body.should == "must include a birthdate parameter"
    end

    ##
    it 'if multiple missing parameters' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&interests[]=physics&gender=male'
      last_response.should be_forbidden
      last_response.body.should == "must include a height parameter\nmust include a birthdate parameter"
    end

    it 'if invalid gender' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=robot&birthdate=1993-07-05&height=1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "gender parameter should match regex: (?-mix:^male$|^female$)"
    end

    it ' if interests is a string' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests=physics'
      last_response.should be_forbidden
      last_response.body.should == "interests parameter must be an Array of Strings"
    end

    it 'if name is an array' do
      get '/bio?deathtime=2013-07-16T10:30:00&name[]=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "name parameter must be a string of only letters"
    end


    ##
    it 'if birthdate is an array' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=robot&birthdate[]=1993-07-05&height=2.2&interests[]=sports'
      last_response.should be_forbidden
      last_response.body.should == "birthdate parameter must be a string in the format: yyyy-mm-dd"
    end

    it 'if birthdate is invalid' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-33&height=1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "birthdate parameter must be a string in the format: yyyy-mm-dd"
    end

    it 'if deathdate is invalid' do
      get '/bio?deathtime=2013-13-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "deathtime parameter must be a string in the format: yyyy-mm-ddThh:mm:ss"
    end

    it 'if deathtime is invalid' do
      get '/bio?deathtime=2013-07-16T10:63:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "deathtime parameter must be a string in the format: yyyy-mm-ddThh:mm:ss"
    end

    it 'if height is not a float' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=word&interests[]=physics'
      last_response.should be_forbidden
      last_response.body.should == "height parameter must be a Float"
    end

    it 'when popular is neither true or false' do
      get '/bio?deathtime=2013-07-16T10:30:00&name=Scott&gender=male&birthdate=1993-07-05&height=1.8&interests[]=physics&popular=trae'
      last_response.should be_forbidden
      last_response.body.should == 'popular parameter must be a boolean'
    end
  end
end

