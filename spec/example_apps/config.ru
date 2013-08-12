require 'sinatra'
require 'sinatra/base'
require "sinatra/reloader"
require 'json'

$:.unshift(File.dirname(__FILE__) + '/../../lib/')

require 'sinatra/chiro'
require File.dirname(__FILE__) + '/server'
require File.dirname(__FILE__) + '/post_test_app'
require File.dirname(__FILE__) + '/classic_app'

run GetTestApp.new(PostTestApp.new(Sinatra::Application))

