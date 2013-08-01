class Package
  include DataMapper::Resource
  property :id, Serial
  property :category, String
  property :packagename, String
  property :versions, String
end
