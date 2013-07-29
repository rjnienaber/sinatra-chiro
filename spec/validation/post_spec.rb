require 'spec_helper'
ru_file = File.dirname(__FILE__) + '/../example_apps/config.ru'
SERVER_APP = Rack::Builder.parse_file(ru_file).first

describe 'Server application' do
  def app
    SERVER_APP
  end

  context 'succeeds' do
    it 'when no query string params verified' do
      get 'test/male/adams'
      last_response.should be_ok
      last_response.body.should == "Congratulations Mr Adams. So far no query string parameters were invalid.<br><br>\n        These were your query string parameters:<br>\n        string = <br>\n        date = <br>\n        time = <br>\n        fixnum = <br>\n        float = <br>\n        datetime = <br>\n        boolean = <br><br>\n        Now try inputting data here:\n       <form action='answers' method='post'>\n        string: <input type='text' name='string_answer'><br>\n        date: <input type='text' name='date_answer'><br>\n        time: <input type='text' name='time_answer'><br>\n        fixnum: <input type='text' name='fixnum_answer'><br>\n        float: <input type='text' name='float_answer'><br>\n        datetime: <input type='text' name='datetime_answer'><br>\n        boolean: <input type='text' name='boolean_answer'><br>\n       <br><input type='submit'></form>"
    end

    it 'when all query string parameters verified' do
      get 'test/male/adams?&string=word&fixnum=13&date=1234-12-12&time=12:00:00&float=1.5&datetime=1234-12-12T12:00:00&boolean=true'
      last_response.should be_ok
      last_response.body.should == "Congratulations Mr Adams. So far no query string parameters were invalid.<br><br>\n        These were your query string parameters:<br>\n        string = word<br>\n        date = 1234-12-12<br>\n        time = 12:00:00<br>\n        fixnum = 13<br>\n        float = 1.5<br>\n        datetime = 1234-12-12T12:00:00<br>\n        boolean = true<br><br>\n        Now try inputting data here:\n       <form action='answers' method='post'>\n        string: <input type='text' name='string_answer'><br>\n        date: <input type='text' name='date_answer'><br>\n        time: <input type='text' name='time_answer'><br>\n        fixnum: <input type='text' name='fixnum_answer'><br>\n        float: <input type='text' name='float_answer'><br>\n        datetime: <input type='text' name='datetime_answer'><br>\n        boolean: <input type='text' name='boolean_answer'><br>\n       <br><input type='submit'></form>"
    end

    it 'when parameter from path is repeated in query string' do
      get '/test/male/adams?string=word&fixnum=13&date=1234-12-12&time=12:00:00&float=1.5&datetime=1234-12-12T12:00:00&boolean=true&gender=female'
      last_response.should be_ok
      last_response.body.should == "Congratulations Mr Adams. So far no query string parameters were invalid.<br><br>\n        These were your query string parameters:<br>\n        string = word<br>\n        date = 1234-12-12<br>\n        time = 12:00:00<br>\n        fixnum = 13<br>\n        float = 1.5<br>\n        datetime = 1234-12-12T12:00:00<br>\n        boolean = true<br><br>\n        Now try inputting data here:\n       <form action='answers' method='post'>\n        string: <input type='text' name='string_answer'><br>\n        date: <input type='text' name='date_answer'><br>\n        time: <input type='text' name='time_answer'><br>\n        fixnum: <input type='text' name='fixnum_answer'><br>\n        float: <input type='text' name='float_answer'><br>\n        datetime: <input type='text' name='datetime_answer'><br>\n        boolean: <input type='text' name='boolean_answer'><br>\n       <br><input type='submit'></form>"
    end

    it 'when parameter from query string is repeated in payload' do
      get '/test/male/adams?string_answer=word'
      last_response.should be_ok
      post '/test/male/adams', {:string_answer => 'apple', :time_answer => '12:00:00', :fixnum_answer => '20', :boolean_answer => 'true', :float_answer => '1.5', :date_answer => '1234-12-12', :datetime_answer => '1234-12-12T12:00:00'}
      last_response.should be_ok
      last_response.body.should == "Well done, those parameters were also valid:<br>\n        string = apple<br>\n        date = 1234-12-12<br>\n        time = 12:00:00<br>\n        fixnum = 20<br>\n        float = 1.5<br>\n        datetime = 1234-12-12T12:00:00<br>\n        boolean = true<br>"
    end


    it 'when all payload parameters entered' do
      get '/test/male/adams'
      last_response.should be_ok
      post '/test/male/adams', {:string_answer => 'apple', :time_answer => '12:00:00', :fixnum_answer => '20', :boolean_answer => 'true', :float_answer => '1.5', :date_answer => '1234-12-12', :datetime_answer => '1234-12-12T12:00:00'}
      last_response.should be_ok
      last_response.body.should == "Well done, those parameters were also valid:<br>\n        string = apple<br>\n        date = 1234-12-12<br>\n        time = 12:00:00<br>\n        fixnum = 20<br>\n        float = 1.5<br>\n        datetime = 1234-12-12T12:00:00<br>\n        boolean = true<br>"
    end
  end


  context 'returns validation error before post' do
    it 'if extra parameter is included' do
      get '/test/male/adams?extra=value'
      last_response.should be_forbidden
      last_response.body.should == "extra is not a valid parameter"
    end

    it 'when path entered incorrectly' do
      get '/test//adams'
      last_response.should be_not_found
    end


    it 'if invalid gender' do
      get '/test/mail/adams'
      last_response.should be_forbidden
      last_response.body.should == "gender parameter should match regex: (?-mix:^male$|^female$)"
    end

    it 'if surname is invalid' do
      get '/test/male/4d4ms'
      last_response.should be_forbidden
      last_response.body.should == "surname parameter must be a string of only letters"
    end

    it 'if datetime is an array' do
      get '/test/male/adams?datetime[]=1233-12-12T12:00:00'
      last_response.should be_forbidden
      last_response.body.should == "datetime parameter must be a string in the format: yyyy-mm-ddThh:mm:ss"
    end

    it 'if date is invalid' do
      get '/test/male/adams?date=1233-12-12T12:00:00'
      last_response.should be_forbidden
      last_response.body.should == "date parameter must be a string in the format: yyyy-mm-dd"
    end

    it 'if float parameter invalid' do
      get '/test/male/adams?float=hey'
      last_response.should be_forbidden
      last_response.body.should == "float parameter must be a Float"
    end

    it 'when boolean is neither true or false' do
      get '/test/male/adams?boolean=eslaf'
      last_response.should be_forbidden
      last_response.body.should == 'boolean parameter must be a boolean'
    end
  end

  context 'returns validation error after post' do
    it 'when string parameter missing' do
      get '/test/male/adams'
      last_response.should be_ok
      post '/form', {:string => ''}
      last_response.should be_forbidden
      last_response.body.should == "string parameter must not be empty"
    end

    it 'when time parameter invalid' do
      get '/test/male/adams'
      last_response.should be_ok
      post '/form', {:time => '2345'}
      last_response.should be_forbidden
      last_response.body.should == "time parameter must be a string in the format: hh:mm:ss<br>time parameter invalid"
    end

    it 'when multiple parameters missing' do
      get '/test/male/adams'
      last_response.should be_ok
      post '/form', {:string => 'apple', :time => '', :fixnum => '', :boolean => ''}
      last_response.body.should == "fixnum parameter must be a Float<br>boolean parameter must be a boolean<br>time parameter must be a string in the format: hh:mm:ss<br>time parameter invalid"
    end
  end
end

