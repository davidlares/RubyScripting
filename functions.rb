#!/usr/bin/ruby
# Author: David E Lares S
# Date: 11-03-2019
# Contact: david.e.lares@gmail.com
# Description: functions

def saluting(name)
  puts "Hello, " + $name
end

def test(a=1,b)
  result = a + b
end

def mult(c,d)
  return c * d
end

print "Please type your name: "
$name = STDIN.gets
saluting($name)

# sending with params
puts test(b = 4)

# multiplying
puts mult(10,40)
