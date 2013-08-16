app_description "Classic style application"

endpoint 'Greeter', 'Greets user by name or defaults to world' do
  query_param(:name, 'name of the user', :default => 'World')
  get '/hi' do
    "Hello #{params[:name]}!"
  end
end
