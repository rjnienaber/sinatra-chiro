# encoding: utf-8
class HelloApp < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Chiro
  require 'pp'

  endpoint 'Fill out a form' do
    named_param(:gender, 'The gender of the user', :optional => false, :type => /^male$|^female$/)
    named_param(:surname, 'The surname of the user', :optional => false)
    query_param(:string, 'title of string field', :type => String, :optional => true)
    query_param(:date, 'title of date field', :type => Date, :optional => true)
    query_param(:time, 'title of time field', :type => Time, :optional => true)
    query_param(:fixnum, 'title of fixnum field', :type => Fixnum, :optional => true)
    query_param(:float, 'title of float field', :type => Float, :optional => true)
    query_param(:datetime, 'title of datetime field', :type => DateTime, :optional => true)
    query_param(:boolean, 'title of boolean field', :type => :boolean, :optional => true)
    query_param(:extras, 'titles of extra fields', :type => Array[String], :optional => true)
    form(:string_answer, 'title of string field', :type => String, :optional => true)
    form(:date_answer, 'title of date field', :type => Date, :optional => true)
    form(:time_answer, 'title of time field', :type => Time, :optional => true)
    form(:fixnum_answer, 'title of fixnum field', :type => Fixnum, :optional => true)
    form(:float_answer, 'title of float field', :type => Float, :optional => true)
    form(:datetime_answer, 'title of datetime field', :type => DateTime, :optional => true)
    form(:boolean_answer, 'title of boolean field', :type => :boolean, :optional => true)
    form(:extras_answer, 'titles of extra fields', :type => Array[String], :optional => true)

    get '/test/:gender/:surname' do
      gender = params[:gender]
      title = case gender
                when 'male' then 'Mr'
                when 'female' then 'Ms'
              end
      "Congratulations #{title} #{params[:surname].capitalize}. So far no query string parameters were invalid.<br><br>
        These were your query string parameters:<br>
        string = #{params[:string]}<br>
        date = #{params[:date]}<br>
        time = #{params[:time]}<br>
        fixnum = #{params[:fixnum]}<br>
        float = #{params[:float]}<br>
        datetime = #{params[:datetime]}<br>
        boolean = #{params[:boolean]}<br><br>
        Now try inputting data here:
       <form action='answers' method='post'>
        string: <input type='text' name='string_answer'><br>
        date: <input type='text' name='date_answer'><br>
        time: <input type='text' name='time_answer'><br>
        fixnum: <input type='text' name='fixnum_answer'><br>
        float: <input type='text' name='float_answer'><br>
        datetime: <input type='text' name='datetime_answer'><br>
        boolean: <input type='text' name='boolean_answer'><br>
       <br><input type='submit'></form>"
       #{params[:extras]}: <input type='text' name='extras_answer'><br>
    end
    post '/test/:gender/:surname' do
      "Well done, those parameters were also valid:<br>
        string = #{params[:string_answer]}<br>
        date = #{params[:date_answer]}<br>
        time = #{params[:time_answer]}<br>
        fixnum = #{params[:fixnum_answer]}<br>
        float = #{params[:float_answer]}<br>
        datetime = #{params[:datetime_answer]}<br>
        boolean = #{params[:boolean_answer]}<br>"
    end
  end


end
