# encoding: utf-8

class HelloApp < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Chiro

  #http://localhost:9292/hi?people[]=richard&people[]=scott&people[]=roger&greeting=hi
  endpoint "Says hi to the caller" do
    query_param(:name, 'The name of the person', :optional => false)
    query_param(:height, 'The persons height', :type => Float, :optional => false)
    query_param(:birthdate, 'The of birth of person', :type => Date, :optional => false)
    query_param(:deathtime, 'Time of death of person', :type => DateTime, :optional => false)
    query_param(:popular, 'Was the person popular', :optional => true, :type => :boolean)
    query_param(:interests, 'The persons interests', :type => Array[String], :optional => false)
    query_param(:gender, 'Gender of the person', :type => /^male$|^female$/, :optional => true)
    query_param(:friends, 'Number of friends of the person', :type => Fixnum, :optional => true)
    #payload(:contact_id, '')

    get '/bio' do
      name = params[:name]
      gender = params[:gender]
      height = params[:height]
      popular = params[:popular]
      friends = params[:friends]
      deathtime = Time.parse("#{params[:deathtime]}")
      deathdate = Date.parse("#{params[:deathtime]}")
      birthdate = Date.parse("#{params[:birthdate]}")
      interests = params[:interests].join(", ")

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

      "#{name.capitalize} was born on #{birthdate.strftime('%d %b %Y')}. #{pronoun.capitalize} was interested in #{interests}, and was #{height}m tall. #{pronoun.capitalize} died at #{deathtime.strftime('%l:%M%P')} on #{deathdate.strftime('%a %d %b %Y')}, to the #{emotion} of #{possessive} #{friends}friends and family."
    end

    returns "e.g. Hello world!"
  end
end

