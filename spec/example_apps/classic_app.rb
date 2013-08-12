require 'sinatra'

app_description "Classic style application"

endpoint 'Greeter', 'Greets user' do
  get '/hi' do
    "Hello World!"
  end
end
