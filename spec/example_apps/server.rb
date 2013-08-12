# encoding: utf-8
class GetTestApp < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Chiro

  app_description "GET parameter tester"

  endpoint 'Query String tester', 'Tests the validation of all query string parameters' do
    query_param(:string, 'arbitrary parameter of string type', :type => String, :optional => true)
    query_param(:date, 'arbitrary parameter of date type', :type => Date, :optional => true)
    query_param(:time, 'arbitrary parameter of time type', :type => Time, :optional => true)
    query_param(:fixnum, 'arbitrary parameter of fixnum type', :type => Fixnum, :optional => true)
    query_param(:float, 'arbitrary parameter of float type', :type => Float, :optional => true)
    query_param(:datetime, 'arbitrary parameter of datetime type', :type => DateTime, :optional => true)
    query_param(:boolean, 'arbitrary parameter of boolean type', :type => :boolean, :optional => true)
    query_param(:array, 'array of extra parameters', :type => Array[String], :optional => true)
    query_param(:gender, 'gender parameter of regexp type', :type => /^male$|^female$/, :optional => true, :type_description => "male|female", :comment => 'Must be "male" or "female"')
    possible_error('invalid_request_error', 400, 'Invalid request errors arise when your request has invalid parameters')
    response({:string => 'Richard', :date => '1981-01-01', :time => '12:00:00', :fixnum => 24, :float => 1.2, :array => [1,2,3,4,5]})

    get '/test/query' do
      "Valid"
    end
  end

  endpoint 'Named String tester', 'Tests the validation of a String type named parameter' do
    named_param(:string, 'arbitrary parameter of string type', :type => String, :optional => true)
    get '/test/named/string/:string' do
      "Valid"
    end
  end

  endpoint 'Named Date tester', 'Tests the validation of a Date type named parameter' do
    named_param(:date, 'arbitrary parameter of date type', :type => Date, :optional => true, :comments => "date")
    get '/test/named/date/:date' do
      "Valid"
    end
  end

  endpoint 'Named Time tester', 'Tests the validation of a Time type named parameter' do
    named_param(:time, 'arbitrary parameter of time type', :type => Time, :optional => true)
    get '/test/named/time/:time' do
      "Valid"
    end
  end

  endpoint 'Named Fixnum tester', 'Tests the validation of a Fixnum type named parameter' do
    named_param(:fixnum, 'arbitrary parameter of fixnum type', :type => Fixnum, :optional => true)
    get '/test/named/fixnum/:fixnum' do
      "Valid"
    end
  end

  endpoint 'Named Float tester', 'Tests the validation of a Float type named parameter' do
    named_param(:float, 'arbitrary parameter of float type', :type => Float, :optional => true)
    get '/test/named/float/:float' do
      "Valid"
    end
  end

  endpoint 'Named Datetime tester', 'Tests the validation of a DateTime type named parameter' do
    named_param(:datetime, 'arbitrary parameter of datetime type', :type => DateTime, :optional => true)
    get '/test/named/datetime/:datetime' do
      "Valid"
    end
  end

  endpoint 'Named Boolean tester', 'Tests the validation of a Boolean type named parameter' do
    named_param(:boolean, 'arbitrary parameter of boolean type', :type => :boolean, :optional => true)
    get '/test/named/boolean/:boolean' do
      "Valid"
    end
  end
end