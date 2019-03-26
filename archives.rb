#!/usr/bin/ruby
# Author: David E Lares S
# Date: 11-03-2019
# Contact: david.e.lares@gmail.com
# Description: archive creation

# create a txt file
archive = File.new("title.txt", "w")

open = File.open('title.txt')
# read lines
while line = open.gets
  puts line
end

# if unable to read a file with nano, vim, pico -> use ruby if have the rights

# other way
IO.foreach('title.txt') { |line|
  puts line
}
