# coding: utf-8
require 'hpricot'
require 'open-uri'



doc = open("ishimoto.html") { |f| Hpricot(f) }

Entry = Struct.new(:img, :title, :date, :ref_num, :doc_num)

entries = doc.search('tr')[7..-1].map do |row|
  ch = row.children
  e = Entry.new
  e.img = ch[2].children[0].children[0].children[0].children[0]['src'].sub('..','http://wwweic.eri.u-tokyo.ac.jp/dl')
  e.title = ch[4].children[0].inner_html
  e.ref_num = ch[6].inner_html.strip.gsub(/<\/?scul37>/, '')
  e.doc_num = ch[7].inner_html.strip.gsub(/<\/?.+?>/, '')
  e
end

# entries.each do |e|
#   puts "#{e.title}\t=IMAGE(\"#{e.img}\")\t#{e.date}\t#{e.ref_num}\t#{e.doc_num}"
# end

  


# ~> -:24:in `<main>': undefined method `url' for #<Entry:0x007fcc4331a968> (NoMethodError)
