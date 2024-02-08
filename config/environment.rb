require "rubygems"
require "bundler"

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

$db = {} # fake database

require "./app/models/device"
require "./app/api/readings_api"
