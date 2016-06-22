# coding: utf-8
require "nokogiri"
require 'open-uri'
require 'set'

entries = []
key_set = Set.new

File.foreach('uris.text').each do |uri|
  doc = open(uri.strip){|f| Nokogiri.HTML(f)}
  keys = doc.xpath('//td[@class="detail_l"]').map(&:text)
  values = doc.xpath('//td[@class="detail_r"]').map(&:text)
  entries<< keys.zip(values).inject({}){|memo,i| memo[i[0]] = i[1]; memo}
  keys.each{|k|key_set<< k}
  sleep(1)
end

# entries.each do |e|
#   puts key_set.map{|k| e[k] || " " }.join("\t")
# end

puts key_set.to_a.join("\t")

