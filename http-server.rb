#!/usr/bin/ruby
# Author: David E Lares S
# Date: 11-03-2019
# Contact: david.e.lares@gmail.com
# Description: web servers

require 'webrick'
root = File.expand_path 'html/index.html'
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root

# provide a hook (message system) if ends
trap 'INT' do server.shutdown end
#start the server
server.start
