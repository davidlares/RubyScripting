#!/usr/bin/ruby
# Author: David E Lares S
# Date: 11-03-2019
# Contact: david.e.lares@gmail.com
# Description: web crawler

# installing anemone -> gem install anemone
require 'anemone'

Anemone.crawl("http://www.davidlares.now.sh") do |anemon|
  anemone.on_every_page do |page|
    puts page.url
  end
end
