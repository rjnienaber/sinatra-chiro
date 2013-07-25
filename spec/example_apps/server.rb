# encoding: utf-8
class HelloApp < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Chiro

  def route_eval
    error = Sinatra::Chiro::MyValidator.new.validate(params, env)
    if error!= nil
      status 403
      throw :halt, "#{error}"
    end
    super
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
      "Is it #{params[:boolean]} that #{params[:fixnum]} #{params[:string]}s disappeared #{time.strftime('at %l:%M%P')} yesterday?"
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

  endpoint 'Failed path' do
    get '/*' do
      status 404
      "path not found"
    end
  end

end
