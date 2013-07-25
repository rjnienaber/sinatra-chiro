require 'spec_helper'
ru_file = File.dirname(__FILE__) + '/../example_apps/config.ru'
SERVER_APP = Rack::Builder.parse_file(ru_file).first

describe 'Server application' do
  def app
    SERVER_APP
  end

  context "bio succeeds" do
    it 'when all parameters except gender, farewell, popular are specified' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&height=1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00'
      last_response.should be_ok
      last_response.body.should == "Keith was born on 11 Nov 1234. She was interested in skiing, sports, music, and was 1.4m tall. She died at  5:00am on Sat 11 Nov 1234, to the indifference of her  friends and family. "
    end

    it 'when all parameters are specified' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&height=1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3&farewell=bye'
      last_response.should be_ok
      last_response.body.should == "Keith was born on 11 Nov 1234. She was interested in skiing, sports, music, and was 1.4m tall. She died at  5:00am on Sat 11 Nov 1234, to the indifference of her 3 friends and family. bye"
    end

    it 'if height is a negative' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&height=-1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3'
      last_response.should be_ok
      last_response.body.should == "Keith was born on 11 Nov 1234. She was interested in skiing, sports, music, and was -1.4m tall. She died at  5:00am on Sat 11 Nov 1234, to the indifference of her 3 friends and family. "
    end

    it 'when parameter from path is repeated in query string' do
      get '/bio/keith/female?interests[]=skiing&name=john&height=1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3'
      last_response.should be_ok
      last_response.body.should == 'Keith was born on 11 Nov 1234. She was interested in skiing, music, and was 1.4m tall. She died at  5:00am on Sat 11 Nov 1234, to the indifference of her 3 friends and family. '
    end
  end

  context 'bio returns validation error' do
    it 'if extra parameter is included' do
      get '/bio/keith/female?interests[]=skiing&extra=para&interests[]=sports&height=1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00'
      last_response.should be_forbidden
      last_response.body.should == "extra is not a valid parameter"
    end

    it 'when parameter in path empty' do
      get '/bio//female?interests[]=skiing&interests[]=sports&height=1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3'
      last_response.should be_not_found
    end

    it 'when query string parameter empty' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&height=1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3&farewell='
      last_response.should be_forbidden
      last_response.body.should == "farewell parameter must not be empty"
    end

    it 'if missing parameter' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00'
      last_response.should be_forbidden
      last_response.body.should == "must include a height parameter"
    end
    it 'if multiple missing parameters' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&interests[]=music&deathtime=1234-11-11T05:00:00&friends=3'
      last_response.should be_forbidden
      last_response.body.should == "must include a height parameter<br>must include a birthdate parameter"
    end

    it 'if invalid gender' do
      get '/bio/keith/femail?interests[]=skiing&height=1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3'
      last_response.should be_forbidden
      last_response.body.should == "gender parameter should match regex: (?-mix:^male$|^female$)"
    end

    it ' if interests is a string' do
      get '/bio/keith/female?interests=sports&height=1.4&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3'
      last_response.should be_forbidden
      last_response.body.should == "interests parameter must be an Array of Strings"
    end

    it 'if name is invalid' do
      get '/bio/keith5/female?interests[]=skiing&interests[]=sports&height=1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3'
      last_response.should be_forbidden
      last_response.body.should == "name parameter must be a string of only letters"
    end

    it 'if birthdate is an array' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&height=1.4&interests[]=music&birthdate[]=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3'
      last_response.should be_forbidden
      last_response.body.should == "birthdate parameter must be a string in the format: yyyy-mm-dd"
    end

    it 'if birthdate is invalid' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&height=1.4&interests[]=music&birthdate=1234-11-1d&deathtime=1234-11-11T05:00:00&friends=3'
      last_response.should be_forbidden
      last_response.body.should == "birthdate parameter must be a string in the format: yyyy-mm-dd"
    end

    it 'if deathtime is invalid' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&height=1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:0000&friends=3'
      last_response.should be_forbidden
      last_response.body.should == "deathtime parameter must be a string in the format: yyyy-mm-ddThh:mm:ss"
    end

    it 'if height is not a float' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&height=word&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3'
      last_response.should be_forbidden
      last_response.body.should == "height parameter must be a Float"
    end

    it 'when popular is neither true or false' do
      get '/bio/keith/female?interests[]=skiing&interests[]=sports&height=1.4&interests[]=music&birthdate=1234-11-11&deathtime=1234-11-11T05:00:00&friends=3&popular=unsure'
      last_response.should be_forbidden
      last_response.body.should == 'popular parameter must be a boolean'
    end
  end
end
