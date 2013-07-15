# encoding: utf-8

class HelloApp < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Chiro

  #http://localhost:9292/hi?people[]=richard&people[]=scott&people[]=roger&greeting=hi
  endpoint "Says hi to the caller" do
    query_param(:name, 'The name of the person')
    query_param(:height, 'The persons height', :type => Float, :optional => false)
    query_param(:birthdate, 'The date of birth of person', :type => Date, :optional => false)
    query_param(:deathtime, 'Time of death of person', :type => DateTime, :optional => false)

    query_param(:interests, 'The persons interests', :type => Array[String])

    query_param(:gender, 'Gender of the person', :type => /^en$|^af-za$|^fr$/)
    #payload(:contact_id, '')



    get '/bio' do
      name = params[:name]               # gets name parameter from url
      gender = params[:gender] || 'it'      # gets gender parameter from url
      height = params[:height]
      deathtime = Time.parse("#{params[:deathtime]}")
      deathdate = Date.parse("#{params[:deathtime]}")
      birthdate = Date.parse("#{params[:birthdate]}")
      interests = params[:interests].join(", ") || "nothing in particular"

      pronoun = case gender
                 when 'male' then 'he'
                 when 'female' then 'she'
                 else 'it'
                end


      "#{name.capitalize} was born on #{birthdate.strftime('%d %b %Y')}. #{pronoun.capitalize} was interested in #{interests}, and was #{height}m tall before #{pronoun} died, at #{deathtime.strftime('%l:%M%P')} on #{deathdate.strftime('%a %d %b %Y')}."
    end




    returns "e.g. Hello world!"
  end
end

