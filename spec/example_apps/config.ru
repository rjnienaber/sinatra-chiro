require 'sinatra'
require 'sinatra/base'
require "sinatra/reloader"
require 'json'

$:.unshift(File.dirname(__FILE__) + '/../../lib/')

require 'sinatra/chiro'
require File.dirname(__FILE__) + '/server'
require File.dirname(__FILE__) + '/other_app'
require File.dirname(__FILE__) + '/classic_app'

run HelloApp.new(AnotherApp.new(Sinatra::Application))

