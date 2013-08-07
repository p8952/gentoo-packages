#!/usr/bin/env ruby

require 'jbuilder'
require 'redis'

@redis = Redis.new(:host => "127.0.0.1", :port => 6379)
@redis.keys.each { |key| @redis.del(key) }

Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/ebuilds/**/*-*.ebuild") do |ebuild|

  f = File.open(ebuild)
  f_ebuild = f.read()
  f.close()

  e_category = File.basename(File.dirname(File.dirname(ebuild)))
  e_packagename = File.basename(ebuild, '.ebuild').sub(/-(?<=-)\d(.*)/, '')
  e_version = File.basename(ebuild, '.ebuild').match(/(?<=-)\d(.*)/).to_s
  e_keywords = f_ebuild.match(/(?<=KEYWORDS=")(.*)(?=")/).to_s
  e_description = f_ebuild.match(/(?<=DESCRIPTION=")(.*)(?=")/).to_s
  e_homepage = f_ebuild.match(/(?<=HOMEPAGE=")(.*)(?=")/).to_s
  e_license = f_ebuild.match(/(?<=LICENSE=")(.*)(?=")/).to_s

  unless e_keywords.nil? or e_keywords.empty? or
         e_description.nil? or e_description.empty? or
         e_homepage.nil? or e_homepage.empty? or
         e_license.nil? or e_license.empty?
  
    e_json = Jbuilder.encode do |json|
      json.set!(e_version) do
        json.keywords(e_keywords)
        json.description(e_description)
        json.homepage(e_homepage)
        json.license(e_license)
      end
    end
 
    puts "#{e_category}/#{e_packagename}-#{e_version}"
    if @redis.exists("#{e_category}/#{e_packagename}")
      @redis.set("#{e_category}/#{e_packagename}", (@redis.get("#{e_category}/#{e_packagename}").sub(/}$/,',') + e_json.sub(/^{/,'')))
    else
      @redis.set("#{e_category}/#{e_packagename}", e_json)
    end

  end

end
