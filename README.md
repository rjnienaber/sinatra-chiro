Chiro
=============

Chiro is a DSL for your sinatra application which generates readable documentation and validates the parameters used in your API. 

The generated documentation includes details of all required parameters for a given route, and can optionally include an example response and possible errors which may occur.

This information can then be viewed in a readable HTML document using a path specified by the user

## Getting Started

Chiro is available as a gem, to install it just install the gem:

    gem install sinatra-chiro

If you're using Bundler, add the gem to Gemfile

    gem 'sinatra-chiro'

Run `bundle-install`

If you clone the github repository, you will have access to the unit tests and example applications. These include a demonstration application which shows some of the basic features of Chiro and a simple yet exhaustive application which uses all validation features for the RSpec unit tests.

## Implementation

In your application file, every request must be contained within an `endpoint` block. This block must also contain any parameters used by the request in order for them to be documented and validated. Below is a simple example demonstrating the declaration of an endpoint.

```ruby
app_description "Greeter Application"

endpoint 'Greeter', 'greets the user by name' do
  named_param(:name, 'name of the user', :type => String)
  query_param(:greeting, 'how the user wants to be greeted', :type => String, :optional => false)
  get '/greet/:name' do
    "#{params[:greeting]}, #{params[:name]}"
  end
end
```

The application must first be named using `app_description`, as shown above, then any endpoints must be declared  in the format:  

    endpoint 'Name of feature', 'description of feature'


## Declaring Parameters

If a parameter received via a request has not been declared, or has been declared improperly, a validation error will be returned. There are three types of parameters which can be declared in the endpoint:

Query Parameters are found within the query string (eg. /greeter?greeting=hello)

    query_param(:greeting, 'how the user wants to be greeted', :type => String, :optional => true)
    
Named Parameters are found between forward slashes in the path (eg. /person/:height)

    named_param(:height, 'the height of the person', :type => Float)
    
Form parameters, which are obtained using a post request.

    form(:birthday, 'the date of birth of the user', :type => Date, :optional => false) 

The first two arguments should be the name of the parameter, and a brief description. 

The `:type` argument determines the standard to which the parameter should be validated. All accepted `:type`s are listed below in the Validation section. If a value for `:type` is not given, it will default to `String` and will be validated as such.

If `:optional` is false, a validation error will be raised when the parameter has not been given. The value of `:optional` defaults to false for named parameters, and true for query and form parameters. 

The argument `:default` can be used to set a default value for an optional parameter, for example: 

```ruby
query_param(:name, 'the name of the person to be greeted', :type => String, :default => 'World')
get '/greet' do
  "Hello #{params[:name]}!"
end
```
Here if no `:name` query parameter is given in the URL, it will default to `'World'` and the application will return `"Hello World!"`


## Regular Expressions

To customise the validation process to validate a parameter according to a regular expression, you substitute the regular expression as the value of the `:type` argument. It is also useful to add to the declaration a `:comment` argument to explain the expression, and `:type_description`, which updates the type in the documentation.

For example, you might want a `:gender` parameter which only accepts "male" or "female", and would want it to be validated accordingly.

```
query_param(:gender, 'gender parameter of regexp type', :type => /^male$|^female$/, :type_description => "male|female", :comment => 'Must be "male" or "female"')
```


## Possible Errors

It is also possible for your generated documentation to include details of possible errors which may occur. These can be declared within the endpoint in a similar way to parameters, but with a description and a status code. For example:

```ruby
possible_error('invalid_request_error', 400, 'Invalid request errors arise when your request has invalid parameters')
```


## Responses

Example responses can also be included this way by including `response` within the endpoint with a hash of all given parameters as the argument. 

```
response({:string => 'Richard', :date => '1981-01-01', :time => '12:00:00', :fixnum => 24, :float => 1.2, :array => [1,2,3,4,5]})
```

This would return the following example response to the documentation:

```
{
  string: Richard
  date: 1981-01-01
  time: 12:00:00
  fixnum: 24
  float: 1.2
  array: [1, 2, 3, 4, 5]
}       
```


## Validation

The following parameter `:type`s are accepted for validation to be performed against:

 * `String`
 * `Fixnum`
 * `Float`
 * `Date`
 * `Time`
 * `DateTime`
 * `:boolean`
 * `Array`
 * a regular expression for matching 

If any validation errors occur when your application is run, a response status code 403 will be returned along with a JSON object containing all errors, for example:

```json
{
  "validation_errors":[
    "name parameter must be a string of only letters", 
    "date parameter must be a string in the format: yyyy-mm-dd"
  ]
}
```

## Documentation

The documentation for a specific route can be viewed by entering the key "help" as a query string parameter in the URL. The user may specify a different help key by including the following at the start of each application file:

    set :help_key, "new_help_key"
    
The documentation for all routes can be viewed using the path "/routes". Similar to the help key, this can be changed by including:

    set :routes_path, "/newroutespath"

The documentation format is determined by a default erb template within Chiro. To use a custom template, somewhere inside the root directory include a folder named "views" containing an erb file with your chosen documentation format. You must then inform Chiro of this by including the following at the start of each application file:
```
set :erb_file, :new_file_name
set :views_location, 'new_views_location'
```
