#!/usr/bin/env ruby

require 'jbuilder'
require 'redis'
require 'uri'

def setup_redis()
  if ENV["REDISCLOUD_URL"]
    uri = URI.parse(ENV["REDISCLOUD_URL"])
    @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  else  
    @redis = Redis.new(:host => "127.0.0.1", :port => 6379)
  end
  @redis.keys.each { |key| puts "Deleting: #{key}"; @redis.del(key) }
end

def parse_ebuild(ebuild)
  f = File.open(ebuild)
  f_ebuild = f.read
  f.close

  e_category = File.basename(File.dirname(File.dirname(ebuild)))
  e_packagename = File.basename(ebuild, '.ebuild').sub(/-(?<=-)\d(.*)/, '')
  e_version = File.basename(ebuild, '.ebuild').match(/(?<=-)\d(.*)/).to_s
  e_keywords = f_ebuild.match(/(?<=KEYWORDS=")(.*)(?=")/).to_s
  e_description = f_ebuild.match(/(?<=DESCRIPTION=")(.*)(?=")/).to_s
  e_homepage = f_ebuild.match(/(?<=HOMEPAGE=")(.*)(?=")/).to_s
  e_license = f_ebuild.match(/(?<=LICENSE=")(.*)(?=")/).to_s

  var_array = [e_keywords, e_description, e_homepage, e_license]
  var_array.each do |var|
    return nil, nil if var.nil? or var.empty?
  end
  
  e_json = Jbuilder.encode do |json|
    json.set!(e_version) do
      json.keywords(e_keywords)
      json.description(e_description)
      json.homepage(e_homepage)
      json.license(e_license)
    end
  end
  key = "#{e_category}/#{e_packagename}"
  return key, e_json
end

setup_redis()
Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/ebuilds/**/*-*.ebuild") do |ebuild|
  key, json = parse_ebuild(ebuild)
  unless key.nil? or json.nil?
    if @redis.exists(key)
      puts "Updating: #{key}"
      @redis.set(key, (@redis.get(key).sub(/}$/,',') + json.sub(/^{/,'')))
    else
      puts "Setting: #{key}"
      @redis.set(key, json)
    end
  end
end
