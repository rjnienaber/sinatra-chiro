require 'sinatra/base'
require "sinatra/reloader"
require 'json'

$:.unshift(File.dirname(__FILE__) + '/../../lib/')

require 'sinatra/chiro'
require File.dirname(__FILE__) + '/application'

run Sinatra::Application

