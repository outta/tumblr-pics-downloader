#!/usr/bin/ruby
require 'open-uri'
require 'digest/md5'
# -------------- parallelization part starts here
require 'thread'

module Enumerable
  def in_parallel_n(n)
    todo = Queue.new
    ts = (1..n).map{
      Thread.new{
        while x = todo.deq
          # Exception.ignoring_exceptions{ yield(x[0]) }
          yield(x[0])
        end
      }
    }

    each{|x| todo << [x]}
    n.times{ todo << nil }
    ts.each{|t| t.join}
  end
end

def Exception.ignoring_exceptions
  begin
    yield
  rescue Exception => e
    STDERR.puts e.message
  end
end

module Enumerable
  def in_parallel
    map{|x| Thread.new{ yield(x) } }.each{|t| t.join}
  end
end
# -------------- parallelization part ends here
# regex = /http:\/\/\d+.media.tumblr.com\/(.*).(jpg|png|gif)/
num = 2
count = 1
max = 25000
done = false
threadsNr = 10

# url = 'http://sofee-records.mmm-tasty.ru/faves'
url = 'onlyfog.mmm-tasty.ru'

if url.include? 'tumblr.com'
  regex = /http:\/\/(\d|[a-zA-Z])*.media.tumblr.com\/(.*).(jpg|png|gif)/
elsif url.include? 'mmm-tasty.ru'
  # regex = /(https:(?:\/*[a-zA-Z]*\.*-*\d*)*(?:\.gif|\.jpg|\.bmp|\.png|\.jpeg))/
  regex = /http:\/\/pp.vk.me\/(.*).(jpg|png|gif|jpeg)/
end

partOfUrl = url.sub(/^http:\/\//, '')
basedir = Dir.pwd + 'savdpixFor ' + "#{partOfUrl}/"

unless File.exists?(basedir)
  Dir.mkdir(basedir)
  puts "folder didn't exist -> created"
end

while not done do
  arr = Array.new
  puts "[+] scraping page #{num}"

  if url.include? 'http'
    pageToOpen = url+'/page/'+num.to_s
  else
    pageToOpen = 'http://'+url+'/page/'+num.to_s
  end

  page = open(pageToOpen) do |p|
    p.each_line do |line|
      if line =~ regex
        arr.push($&)
        puts $&
      end
    end
  end

  done = true if arr.size == 0

  arr.each.in_parallel_n(threadsNr) do |pic|
    begin
      f = File.new("#{basedir}#{Digest::MD5.hexdigest(pic)}.#{pic.scan(/(jpg|png|gif)/)[0][0]}", "wb")
      f.write(open(pic).read)
      f.close
      puts "[+] wrote pic #{count}"
      count += 1
      exit if count == max
      # sleep 1 + rand(2)
    rescue
      next
    end
  end
  num += 1
end
