app_description "Classic style application"

set :erb_file, :test
set :views_location, File.join(File.dirname(__FILE__), 'views')
set :help_key, "helpme"


endpoint 'Greeter', 'Greets user' do
  get '/hi' do
    "Hello World!"
  end
end


