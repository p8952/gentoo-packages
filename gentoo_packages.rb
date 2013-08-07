require 'json'
require 'redis'
require 'sinatra'

@@redis = Redis.new(:host => "127.0.0.1", :port => 6379)

class GentooPackages < Sinatra::Application
  require_relative 'routes/init'
  require_relative 'helpers/init'
end
