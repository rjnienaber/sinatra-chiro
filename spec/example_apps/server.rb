# encoding: utf-8
class HelloApp < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Chiro

  def route_eval
    error = Sinatra::Chiro::MyValidator.new.validate(params, env)
    if error == "not found"
      status 404
      throw :halt, "Path not found"
    elsif error!= nil
      status 403
      throw :halt, "#{error}"
    end
    super
  end


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
    payload(:string_answer, 'title of string field', :type => String, :optional => true)
    payload(:date_answer, 'title of date field', :type => Date, :optional => true)
    payload(:time_answer, 'title of time field', :type => Time, :optional => true)
    payload(:fixnum_answer, 'title of fixnum field', :type => Fixnum, :optional => true)
    payload(:float_answer, 'title of float field', :type => Float, :optional => true)
    payload(:datetime_answer, 'title of datetime field', :type => DateTime, :optional => true)
    payload(:boolean_answer, 'title of boolean field', :type => :boolean, :optional => true)
    payload(:extras_answer, 'titles of extra fields', :type => Array[String], :optional => true)

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
      gender = params[:gender]
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




  endpoint 'Fill out a form' do
    payload(:string, 'User input string', :type => String, :optional => true)
    payload(:fixnum, 'User input float', :type => Float, :optional => true)
    payload(:boolean, 'User input date', :type => :boolean, :optional => true)
    payload(:time, 'User input word', :type => Time, :optional => true)

    get '/form' do
      "<form action='form' method='post'>
        Enter a number: <input type='text' name='fixnum'><br>
        Enter a noun: <input type='text' name='string'><br>
        Enter a time: <input type='text' name='time'><br>
        Enter a boolean: <input type='text' name='boolean'>
       <br><input type='submit'></form>"
    end

    post '/form' do
      time = Time.parse("#{params[:time]}")
      "Is it #{params[:boolean]} that #{params[:fixnum]} #{params[:string]}s disappeared #{time.strftime('at %l:%M%P')} yesterday? #{if params[:fixnum] == 3 then "three!" end}"
    end

  end

  endpoint 'Gives bio of person' do
    named_param(:name, 'The name of the person', :optional => false)
    query_param(:farewell, 'Says goodbye to the user', :type => String, :optional => true)
    query_param(:height, 'The persons height', :type => Float, :optional => false)
    query_param(:birthdate, 'Time of birth of person', :type => Date, :optional => false)
    query_param(:deathtime, 'Time of death of person', :type => DateTime, :optional => false)
    query_param(:popular, 'Was the person popular', :optional => true, :type => :boolean)
    query_param(:interests, 'The persons interests', :type => Array[String], :optional => false)
    query_param(:gender, 'Gender of the person', :type => /^male$|^female$/, :optional => true)
    query_param(:friends, 'Number of friends of the person', :type => Fixnum, :optional => true)

    get '/bio/:name/:gender' do
      name = params[:name]
      gender = params[:gender]
      height = params[:height]
      popular = params[:popular]
      friends = params[:friends]
      deathtime = Time.parse("#{params[:deathtime]}")
      deathdate = Date.parse("#{params[:deathtime]}")
      birthdate = Date.parse("#{params[:birthdate]}")
      interests = params[:interests].join(", ")
      farewell = params[:farewell]

      emotion = case popular
                  when 'true' then 'disappointment'
                  when 'false' then 'relief'
                  else 'indifference'
                end

      pronoun = case gender
                 when 'male' then 'he'
                 when 'female' then 'she'
                 else 'it'
                end

      possessive = case gender
                  when 'male' then 'his'
                  when 'female' then 'her'
                  else 'its'
                   end

      "#{name.capitalize} was born on #{birthdate.strftime('%d %b %Y')}. #{pronoun.capitalize} was interested in #{interests}, and was #{height}m tall. #{pronoun.capitalize} died at #{deathtime.strftime('%l:%M%P')} on #{deathdate.strftime('%a %d %b %Y')}, to the #{emotion} of #{possessive} #{friends} friends and family. #{farewell}"
    end
  end


end
