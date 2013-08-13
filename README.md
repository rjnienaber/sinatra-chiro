
chiro
=============

Chiro is a DSL for your sinatra application which generates readable documentation and validates the parameters used in your API. 

The generated documentation includes details of all required parameters for a given route, and can optionally include an example response and possible errors which may occur.

This information can then be viewed for a specific route by including "help" as a query string parameter in the relevent URL, or the documentation for all routes can be viewed by using the path /routes.


## Implementation

In your server file, every request must be contained within an `endpoint` block. This block must also contain any parameters used by the request in order for them to be documented and validated. Below is a simple example demonstrating the declaration of an endpoint.

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

If a parameter received via a request has not bee declared, or has been declared improperly, a validation error will arise. There are three types of parameters which can be declared in the endpoint:

Query Parameters are found within the query string (eg. /greeter?greeting=hello)

    query_param(:greeting, 'how the user wants to be greeted', :type => String, :optional => true)
    
Named Parameters are found between forward slashes in the path (eg. /person/:height)

    named_param(:height, 'the height of the person', :type => Float)
    
Form parameters, which are obtained using a post request.

    form(:birthday, 'the date of birth of the user', :type => Date, :optional => false) 

The first two arguments should be the name of the parameter, and a brief description. 

The `:type` argument can be one of `String`, `Fixnum`, `Float`, `Date`, `Time`, `DateTime`, `:boolean`, `Array` or the regular expression for matching. If a value for `:type` is not given, it will default to `String` and will be validated as such.

If `:optional` is false, a validation error will be raised when the parameter has not been given. The value of `:optional` defaults to false for named parameters, and true for query and form parameters. 

If your application assigns a default value to parameters, the optional argument `:default` can be used to tell this to Chiro. For example:

```ruby
query_param(:greeting, 'how the user wants to be greeted', :type => String, :optional => true, :default => 'hello')
get '/greet/:name' do
  greeting = params[:greeting] || 'Hello'
  "#{greeting}"
end
```


## Regular Expressions

To customise the validation process to validate a parameter according to a regular expression, you substitute the regular expression at the value of the `:type` argument. It is also useful to add to the declaration a `:comment` argument to explain the expression, and `:type_description`, which updates the type in the documentation.

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

If any validation errors occur when your application is run, a response status code 403 will be returned along with a JSON object containing all errors, for example:

```json
{
  "validation_errors":[
    "name parameter must be a string of only letters", 
    "date parameter must be a string in the format: yyyy-mm-dd"
  ]
}
```

Here is a list of all possible validation errors and their causes:

```ruby
# when parameter is of the wrong type
"[boolean type parameter] parameter must be true or false"
"[array type parameter] parameter must be an Array of Strings"
"[date type parameter] parameter must be a string in the format: yyyy-mm-dd"
"[time type parameter] parameter must be a string in the format: hh:mm:ss"
"[datetime type parameter] parameter must be a string in the format: yyyy-mm-ddThh:mm:ss"
"[float type parameter] parameter must be a float"
"[fixnum type parameter] parameter must be an integer"
"[string type parameter] parameter must be a string of only letters"

# when a non-optional parameter is not included
"must include a [non-optional parameter] parameter"

# when a parameter is included which has not been declared in the endpoint
"[parameter] is not a valid parameter"

# when an ISO 8601 date is invalid, eg. a non existent date
"[time, date, or datetime parameter] parameter invalid"

# when regular expression is not matched
"[regexp type parameter] parameter should match regexp: [regular expression to be matched]"

# when a parameter is left blank
"[parameter] parameter must not be empty"
```

