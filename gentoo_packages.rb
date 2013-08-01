require 'sinatra'
require 'data_mapper'
require 'json'

DataMapper.setup(:default, "sqlite3://#{File.expand_path(File.dirname(__FILE__))}/lib/db.sqlite")
DataMapper::Property::String.length(255)

class GentooPackages < Sinatra::Application
  require_relative 'models/init'
  require_relative 'routes/init'
  require_relative 'lib/init'

  DataMapper.finalize
  DataMapper.auto_upgrade!
end
