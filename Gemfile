source 'https://rubygems.org'
gem 'sinatra'
gem 'rake'
gem 'jbuilder'
gem 'data_mapper'

group :production do
  ruby "2.0.0"
  gem 'thin'
  gem 'dm-postgres-adapter'
end

group :development do
  gem 'dm-sqlite-adapter'
end
