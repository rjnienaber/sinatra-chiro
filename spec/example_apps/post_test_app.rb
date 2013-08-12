class PostTestApp < Sinatra::Base
  register Sinatra::Chiro

  app_description "POST parameter tester"


  endpoint 'Form String tester', 'Tests the validation of a String type form parameter' do
    form(:string, 'arbitrary parameter of string type', :type => String, :optional => false)
    post '/test/form/string' do
      "Valid"
    end
  end

  endpoint 'Form Date tester', 'Tests the validation of a Date type form parameter' do
    form(:date, 'arbitrary parameter of date type', :type => Date, :optional => false)
    response({:date => '1993-07-05'})
    post '/test/form/date' do
      "Valid"
    end
  end

  endpoint 'Form Time tester', 'Tests the validation of a Time type form parameter' do
    form(:time, 'arbitrary parameter of time type', :type => Time, :optional => false)
    post '/test/form/time' do
      "Valid"
    end
  end

  endpoint 'Form Fixnum tester', 'Tests the validation of a Fixnum type form parameter' do
    form(:fixnum, 'arbitrary parameter of fixnum type', :type => Fixnum, :optional => false)
    post '/test/form/fixnum' do
      "Valid"
    end
  end

  endpoint 'Form Float tester', 'Tests the validation of a Float type form parameter' do
    form(:float, 'arbitrary parameter of float type', :type => Float, :optional => false)
    post '/test/form/float' do
      "Valid"
    end
  end

  endpoint 'Form Datetime tester', 'Tests the validation of a Datetime type form parameter' do
    form(:datetime, 'arbitrary parameter of datetime type', :type => DateTime, :optional => false)
    post '/test/form/datetime' do
      "Valid"
    end
  end

  endpoint 'Form Boolean tester', 'Tests the validation of a Boolean type form parameter' do
    form(:boolean, 'arbitrary parameter of boolean type', :type => :boolean, :optional => false)
    post '/test/form/boolean' do
      "Valid"
    end
  end

  endpoint 'Form Regexp tester', 'Tests the validation of a gender form parameter which is a regular expression type' do
    form(:gender, 'gender parameter of regexp type', :type => /^male$|^female$/, :optional => false, :comment => 'Must be "male" or "female"')
    post '/test/form/gender' do
      "Valid"
    end
  end
end

