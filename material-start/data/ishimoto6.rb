# coding: utf-8
require 'net/http'
require 'json'

File.foreach('content_uris.txt').each_with_index do |url, i|
  url.strip!
  if url.empty?
    puts ""
    next
  end
  uri = URI(url)
  response = Net::HTTP.get(uri)
  path = "json/%05d.json"%(i+1)
  File.write(path, response)
  sleep 1
end
