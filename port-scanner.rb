#!/usr/bin/ruby
# Author: David E Lares S
# Date: 11-03-2019
# Contact: david.e.lares@gmail.com
# Description: port scanner

require 'socket'
require 'timeout'

print "IP/URL Address: "
ip = gets.chomp # gets the string, like stdin
ports = 20..80

# setting the port
ports.each do |p|
  # genereting connection logic
  begin
    Timeout::timeout(10) { TCPSocket.new("#{ip}", p) }
  rescue
    puts "Closed: #{p}"
    else
      puts "Open port #{p}"
    end
end
