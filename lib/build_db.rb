#!/usr/bin/env ruby

require 'data_mapper'
require 'jbuilder'

DataMapper.setup(:default, "sqlite3://#{File.expand_path(File.dirname(__FILE__))}/db.sqlite")
DataMapper::Property::String.length(255)

class Package
  include DataMapper::Resource
  property :id, Serial
  property :category, String
  property :packagename, String
  property :versions, Text
end
DataMapper.finalize
DataMapper.auto_migrate!

Dir.glob('/usr/portage/**/*-*.ebuild') do |ebuild|
  f = File.open(ebuild)
  f_ebuild = f.read()
  f.close()

  e_category = File.basename(File.dirname(File.dirname(ebuild)))
  e_packagename = File.basename(ebuild, '.ebuild').sub(/-(?<=-)\d(.*)/, '')
  e_version = File.basename(ebuild, '.ebuild').match(/(?<=-)\d(.*)/)
  e_keywords = f_ebuild.match(/(?<=KEYWORDS=")(.*)(?=")/).to_s
  e_description = f_ebuild.match(/(?<=DESCRIPTION=")(.*)(?=")/).to_s
  e_homepage = f_ebuild.match(/(?<=HOMEPAGE=")(.*)(?=")/).to_s
  e_license = f_ebuild.match(/(?<=LICENSE=")(.*)(?=")/).to_s

  unless e_keywords.nil? or e_keywords.empty? or 
         e_description.nil? or e_description.empty? or 
         e_homepage.nil? or e_homepage.empty? or
         e_license.nil? or e_license.empty?

    e_json = Jbuilder.encode do |json|
      json.version do
        json.number(e_version)
        json.keywords(e_keywords)
        json.description(e_description)
        json.homepage(e_homepage)
        json.license(e_license)
      end
    end
    
    package = Package.first(:category => e_category, :packagename => e_packagename)
    if package.nil?
      puts "Creating : #{e_category}/#{e_packagename}-#{e_version}"
      package = Package.create(
        :category => e_category,
        :packagename => e_packagename,
        :versions => e_json,
      )
      package.save
    else
      puts "Updating : #{e_category}/#{e_packagename}-#{e_version}"
      package.update(:versions => (package.versions + '|&|' + e_json).split('|&|').sort.reverse.join('|&|'))
    end
  end
end
