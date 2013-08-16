app_description "Demonstration application"

# required parameter arguments are :name, :description
# optional parameter arguments are :type, :optional, :default, :comment, :type_description

endpoint 'Biography', 'Gives a description of a person' do
  named_param(:name, 'the name of the person')
  named_param(:surname, 'the surname of the person')
  query_param(:title, 'the title of the person', :default => 'king')
  query_param(:birthday, 'the date of birth of the person', :type => Date, :optional => false)
  query_param(:gender, 'the gender of the person', :type => /^male$|^female$/, :type_description => "male|female", :optional => false, :comment => 'Must be "male" or "female"')
  possible_error('invalid_request_error', 400, 'Invalid request errors arise when your request has invalid parameters')
  possible_error('page_not_found', 404, 'Error may occur if page has been removed')
  response({:name => 'Scott', :surname => "Adams", :birthday => '1993-07-05', :title => 'Sir', :gender => 'male'})


  get '/bio/:name/:surname' do
    "#{params[:title]} #{params[:name]} #{params[:surname]} is a #{params[:gender]} human, and was born on #{params[:birthday]}. "
  end
end


endpoint 'Form', 'boolean and float form parameters are obtained via POST route' do
  form(:number, 'arbitrary number parameter', :type => Float, :default => 0.0)
  form(:bool, 'arbitrary boolean parameter', :type => :boolean)
  possible_error('invalid_request_error', 400, 'Invalid request errors arise when your request has invalid parameters')
  response({:number => '3.1415926', :bool => 'true'})

  post '/results' do    
    number = params[:number] || 0.0
    "Your number was #{number}, is that #{params[:bool]}"
  end
end
