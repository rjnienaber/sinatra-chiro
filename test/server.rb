# encoding: utf-8

class HelloApp < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Chiro

  #http://localhost:9292/hi/hello?people[]=roger&people[]=john
  endpoint "Says hi to the caller" do
    named_param(:greeting, 'How you want to be greeted')
    named_param(:people, 'Who you want to greet', :type => Array[String])
    query_param(:language, 'Language to be greeted in', :type => /^en$|^af-za$|^fr$/)
    #payload(:contact_id, '')

    get '/hi/:greeting' do
      greeting = params[:greeting] || 'Hello'
      language = params[:language] || 'en'

      greetee = if params[:people]
                  params[:people].join(", ")
                else
                  case language
                    when 'af-za' then 'wêreld'
                    when 'fr' then 'monde'
                    else 'world'
                  end
                end

      "#{greeting} #{greetee}!"
    end

    returns "e.g. Hello world!"
  end
end

