#!/usr/bin/ruby
# Author: David E Lares S
# Date: 11-03-2019
# Contact: david.e.lares@gmail.com
# Description: web crawler

require 'anemone'
require 'nokogiri'
require 'net/http'
require 'data_mapper' # data comparisor
require 'dm-sqlite-adapter' # stored in database

class Url
  include DataMapper::Resource
  # database structure
  property :id, Serial
  property :url, Text, :required => true
  property :code, Integer
  property :redirect, Text
  property :depth, Integer # more URI elements, more depth
  property :forms, String, :length => 256
  property :createdAt, DateTime, :default => DateTime.now
  property :update_at, DateTime, :default => DateTime.now

# detect and read HTTP (define URL structure)
def read_http(url)
  uri = URI(url)
  Net::HTTP.get_response(uri)
end

def read_https(url)
  response = nil # Null
  uri = URI(url)
  http = NET:HTTP.new(uri.host, uri.port)
  http.use_ssl = true # forcing the HTTPS
  http.start do |http|
    response = Net::HTTP.get_response(uri)
  end
  response
end

# exec script if the URL exists
raise "Should insert a valid URL" unless ARGV.count == 1
site = ARGV[0]
# the ? in query represents a boolean statement
site = 'http://' + ARGV[0] unless ARGV[0].start_with?('http://') || ARGV[0].start_with?('https://')
# Database
db_name = 'anyname.db'
db_name = site.gsub("http://","") if site.start_with?("http://")
db_name = site.gsub("https://","") if site.start_with?("https://")
db_name += ".db"

#string DB connection
DataMapper.setup(:default, "sqlite3://#{File.join(Dir.pwd, db_name)}")
# Closing Connection
DataMapper.finalize
# inject data
DataMapper.auto_migrate!
puts "Script running to Crawl URLs: #{site}"

Url.all.each do |url|
  puts "#{url}"
end

puts "Showing crawling results"
page_count = 0

Anemone.crawl("#{site}", discar_page_bodies => true, :depth_limit => 2) do |anemone|
  anemone.on_every_page do |page|
    # evaluation
    res = read_http(page.url) if page.url.instance_of?(URI::HTTP)
    res = read_https(page.url) if page.url.instance_of?(URI::HTTPS)
    # set a redirection if http code status is 301
    puts "#{page.url} is a redirection to #{res['location']}" if res.code.to_i == 301
    if res.code.to_i == 200
      # parsing (analyzing)
      doc = Nokogiri::HTML(res.body)
      puts "#{page.url} (level #{page.depth}. form: #{doc.search("//from").count})"
    end
    puts "#{page.url} not found" if res.code.to_i == 404
    puts "#{page.url} require authorization" if res.code.to_i == 401
    puts "#{page.url} responds error message" if res.code.to_i == 500

    if ! Url.first(:url => page.url)
      u = Url.new
      u.url = page.url
      u.depth = page.depth
      # check for css element and storage in database
      u.forms = doc.css("form").map {|a| (a['name'].nil?) ? "nonamed" : a['name']}.compact.to_s.gsub("\n",",") unless doc.nil?
      u.code = res.code.to_i # response code to Integer
      u.redirect = res['location'] if res.code.to_i == 301
      ret = u.save
      page_count += 1
      if ! ret
        puts "#{page.url}"
        u.errors.each do |e|
          puts " * #{e}"
        end
      end
    end
  end
end

puts "#{page_count} the urls are stored in #{db_name}"
# ARGV davidlares.now.sh
end
