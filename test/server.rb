# encoding: utf-8

class HelloApp < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Chiro

  #http://localhost:9292/hi?people[]=richard&people[]=scott&people[]=roger&greeting=hi
  endpoint "Says hi to the caller" do
    query_param(:greeting, 'How you want to be greeted')
    query_param(:year, 'The year to greet people with', :type => Fixnum, :optional => false)
    query_param(:people, 'Who you want to greet', :type => Array[String], :optional => false)
    query_param(:language, 'Language to be greeted in', :type => /^en$|^af-za$|^fr$/)
    #payload(:contact_id, '')



    get '/hi' do
      greeting = params[:greeting] || 'Hello'   # gets greeting parameter from url
      language = params[:language] || 'en'      # gets language parameter from url
      year = params[:year].to_i                 # gets year parameter from url

      greetee = if params[:people]
                  params[:people].join(", ")
                else
                  case language
                    when 'af-za' then 'wêreld'
                    when 'fr' then 'monde'
                    else 'world'
                  end
                end                              # if no value param for people given in url, use language given for world

      "#{greeting} #{greetee}! Happy new year for #{year}"
    end




    returns "e.g. Hello world!"
  end
end

