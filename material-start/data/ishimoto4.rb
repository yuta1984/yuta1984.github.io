# coding: utf-8
require 'net/http'
require 'json'
 



File.foreach('content_uris.txt').each do |url|
  url.strip!
  if url.empty?
    puts ""
    next
  end
  uri = URI(url)
  response = Net::HTTP.get(uri)
  obj = JSON.parse(response)
  img = obj["ResponseData"]["TotalResults"]
  puts img
  sleep 1
end
