# coding: utf-8
require "nokogiri"
require 'open-uri'
require 'set'


File.foreach('uris.text').each do |uri|
  id = uri.split('_').last
  puts "http://wwweic.eri.u-tokyo.ac.jp/dl/contents/api_contents?IS_DBID=G0000002erilib&amp;IS_RKEY_1=#{id}"
end
