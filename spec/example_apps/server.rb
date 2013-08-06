# encoding: utf-8
class HelloApp < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Chiro

  endpoint 'Query string validation tester' do
    query_param(:string, 'arbitrary parameter of string type', :type => String, :optional => true)
    query_param(:date, 'arbitrary parameter of date type', :type => Date, :optional => true)
    query_param(:time, 'arbitrary parameter of time type', :type => Time, :optional => true)
    query_param(:fixnum, 'arbitrary parameter of fixnum type', :type => Fixnum, :optional => true)
    query_param(:float, 'arbitrary parameter of float type', :type => Float, :optional => true)
    query_param(:datetime, 'arbitrary parameter of datetime type', :type => DateTime, :optional => true)
    query_param(:boolean, 'arbitrary parameter of boolean type', :type => :boolean, :optional => true)
    query_param(:array, 'array of extra parameters', :type => Array[String], :optional => true)
    query_param(:gender, 'gender parameter of regexp type', :type => /^male$|^female$/, :optional => true)
    possible_error('invalid_request_error', 400, 'Invalid request errors arise when your request has invalid parameters')
    response({:string => 'Richard', :date => '1981-01-01', :time => '12:00:00', :fixnum => 24, :float => 1.2, :array => [1,2,3,4,5]})

    get '/test/query' do
      "Valid"
    end


  end

  endpoint 'String named parameter validation tester' do
    named_param(:string, 'arbitrary parameter of string type', :type => String, :optional => true)
    get '/test/named/string/:string' do
      "Valid"
    end
  end

  endpoint 'Date named parameter validation tester' do
    named_param(:date, 'arbitrary parameter of date type', :type => Date, :optional => true, :comments => "date")
    get '/test/named/date/:date' do
      "Valid"
    end
  end

  endpoint 'Time named parameter validation tester' do
    named_param(:time, 'arbitrary parameter of time type', :type => Time, :optional => true)
    get '/test/named/time/:time' do
      "Valid"
    end
  end

  endpoint 'Fixnum named parameter validation tester' do
    named_param(:fixnum, 'arbitrary parameter of fixnum type', :type => Fixnum, :optional => true)
    get '/test/named/fixnum/:fixnum' do
      "Valid"
    end
  end

  endpoint 'Float named parameter validation tester' do
    named_param(:float, 'arbitrary parameter of float type', :type => Float, :optional => true)
    get '/test/named/float/:float' do
      "Valid"
    end
  end

  endpoint 'Datetime named parameter validation tester' do
    named_param(:datetime, 'arbitrary parameter of datetime type', :type => DateTime, :optional => true)
    get '/test/named/datetime/:datetime' do
      "Valid"
    end
  end

  endpoint 'Boolean named parameter validation tester' do
    named_param(:boolean, 'arbitrary parameter of boolean type', :type => :boolean, :optional => true)
    get '/test/named/boolean/:boolean' do
      "Valid"
    end
  end

  endpoint 'String type form parameter validation tester' do
    form(:string, 'arbitrary parameter of string type', :type => String, :optional => false)
    post '/test/form/string' do
      "Valid"
    end
  end

  endpoint 'Date type form parameter validation tester' do
    form(:date, 'arbitrary parameter of date type', :type => Date, :optional => false)
    response({:date => '1993-07-05'})
    post '/test/form/date' do
      "Valid"
    end
  end

  endpoint 'Time type form parameter validation tester' do
    form(:time, 'arbitrary parameter of time type', :type => Time, :optional => false)
    post '/test/form/time' do
      "Valid"
    end
  end

  endpoint 'Fixnum type form parameter validation tester' do
    form(:fixnum, 'arbitrary parameter of fixnum type', :type => Fixnum, :optional => false)
    post '/test/form/fixnum' do
      "Valid"
    end
  end

  endpoint 'Float type form parameter validation tester' do
    form(:float, 'arbitrary parameter of float type', :type => Float, :optional => false)
    post '/test/form/float' do
      "Valid"
    end
  end

  endpoint 'Datetime type form parameter validation tester' do
    form(:datetime, 'arbitrary parameter of datetime type', :type => DateTime, :optional => false)
    post '/test/form/datetime' do
      "Valid"
    end
  end

  endpoint 'Boolean type form parameter validation tester' do
    form(:boolean, 'arbitrary parameter of boolean type', :type => :boolean, :optional => false)
    post '/test/form/boolean' do
      "Valid"
    end
  end

  endpoint 'Regexp type form parameter validation tester' do
    form(:gender, 'gender parameter of regexp type', :type => /^male$|^female$/, :optional => false)
    post '/test/form/gender' do
      "Valid"
    end
  end
end