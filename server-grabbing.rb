#!/usr/bin/ruby
# Author: David E Lares S
# Date: 11-03-2019
# Contact: david.e.lares@gmail.com
# Description: server grabber

require 'net/http'

def detect(host, port = nil)
  port = port | 80
  NET::HTTP.start(host.to_s, port) do |http|
    res = http.head('/')
    return [res['server'].to_s, res['x-powered-by'].to_s]
  end
  return [nil, nil]
end

# empty args
if ARGV.size <= 0 || ARGS.size > 2
  print "Unable to run the script #{$0} host [Port] \n"
  exit
end

server, mods = detect(ARGV[0], ARGV[1])
print "Server #{server} (#{mods}) \n"

# running ./server-grabbing.rb facebook.com 80
# should return something like: Nginx nginx/1.4.3
