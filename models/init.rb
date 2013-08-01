class Package
  include DataMapper::Resource
  property :id, Serial
  property :category, String
  property :packagename, String
  property :versions, String
  property :keywords, String
  property :descriptions, String
  property :homepages, String
  property :licenses, String
end
