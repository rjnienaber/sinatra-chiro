# encoding: utf-8
class HelloApp < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Chiro
  require 'pp'

  endpoint 'Query string validation tester' do
    query_param(:string, 'parameter of string type', :type => String, :optional => true)
    query_param(:date, 'parameter of date type', :type => Date, :optional => true)
    query_param(:time, 'parameter of time type', :type => Time, :optional => true)
    query_param(:fixnum, 'parameter of fixnum type', :type => Fixnum, :optional => true)
    query_param(:float, 'parameter of float type', :type => Float, :optional => true)
    query_param(:datetime, 'parameter of datetime type', :type => DateTime, :optional => true)
    query_param(:boolean, 'parameter of boolean type', :type => :boolean, :optional => true)
    query_param(:array, 'array of extra parameters', :type => Array[String], :optional => true)
    get '/test/query' do
      "Valid"
    end
  end



  endpoint 'String named parameter validation tester' do
    named_param(:string, 'parameter of string type', :type => String, :optional => true)
    get '/test/named/string/:string' do
      "Valid"
    end
  end

  endpoint 'Date named parameter validation tester' do
    named_param(:date, 'parameter of date type', :type => Date, :optional => true)
    get '/test/named/date/:date' do
      "Valid"
    end
  end

  endpoint 'Time named parameter validation tester' do
    named_param(:time, 'parameter of time type', :type => Time, :optional => true)
    get '/test/named/time/:time' do
      "Valid"
    end
  end

  endpoint 'Fixnum named parameter validation tester' do
    named_param(:fixnum, 'parameter of fixnum type', :type => Fixnum, :optional => true)
    get '/test/named/fixnum/:fixnum' do
      "Valid"
    end
  end

  endpoint 'Float named parameter validation tester' do
    named_param(:float, 'parameter of float type', :type => Float, :optional => true)
    get '/test/named/float/:float' do
      "Valid"
    end
  end

  endpoint 'Datetime named parameter validation tester' do
    named_param(:datetime, 'parameter of datetime type', :type => DateTime, :optional => true)
    get '/test/named/datetime/:datetime' do
      "Valid"
    end
  end

  endpoint 'Boolean named parameter validation tester' do
    named_param(:boolean, 'parameter of boolean type', :type => :boolean, :optional => true)
    get '/test/named/boolean/:boolean' do
      "Valid"
    end
  end




  endpoint 'String type form parameter validation tester' do
    form(:string, 'parameter of string type', :type => String, :optional => false)
    post '/test/form/string' do
      "Valid"
    end
  end

  endpoint 'Date type form parameter validation tester' do
    form(:date, 'parameter of date type', :type => Date, :optional => false)
    post '/test/form/date' do
      "Valid"
    end
  end

  endpoint 'Time type form parameter validation tester' do
    form(:time, 'parameter of time type', :type => Time, :optional => false)
    post '/test/form/time' do
      "Valid"
    end
  end

  endpoint 'Fixnum type form parameter validation tester' do
    form(:fixnum, 'parameter of fixnum type', :type => Fixnum, :optional => false)
    post '/test/form/fixnum' do
      "Valid"
    end
  end

  endpoint 'Float type form parameter validation tester' do
    form(:float, 'parameter of float type', :type => Float, :optional => false)
    post '/test/form/float' do
      "Valid"
    end
  end

  endpoint 'Datetime type form parameter validation tester' do
    form(:datetime, 'parameter of datetime type', :type => DateTime, :optional => false)
    post '/test/form/datetime' do
      "Valid"
    end
  end

  endpoint 'Boolean type form parameter validation tester' do
    form(:boolean, 'parameter of boolean type', :type => :boolean, :optional => false)
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
