# encoding: utf-8

class HelloApp < Sinatra::Base
  register Sinatra::Chiro

  endpoint "Says hi to the caller" do
    named_param(:greeting, 'How you want to be greeted')
    named_param(:people, 'How you want to be greeted', :type => Array[String])
    query_param(:language, 'Language to be greeted in', :type => 'en|af-za|fr')
    #payload(:contact_id, '')

    get '/hi/:greeting' do
      greeting = params[:greeting] || 'Hello'
      language = params[:language] || 'en'

      world = case language
                when 'af-za' then 'wêreld'
                when 'fr' then 'monde'
                else 'world'
              end

      "#{greeting} #{world}!"
    end

    returns "e.g. Hello world!"
  end
end

