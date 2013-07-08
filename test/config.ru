require 'sinatra'
require 'sinatra/base'
require 'json'

$:.unshift(File.dirname(__FILE__) + '/../lib/')

require 'sinatra/chiro'
require File.dirname(__FILE__) + '/server'

use Sinatra::Chiro::Middleware

run HelloApp

