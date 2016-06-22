# coding: utf-8

require "open-uri"



File.foreach('first_img.txt').each_with_index do |url, i|
  url.strip!
  if url.empty?
    puts ""
    next
  end
  puts url
  path = "thumbnails/%05d.jpg"%(i+1)
  open(path, 'wb') do |output|
    open(url) do |data|
      output.write(data.read)
    end
  end
end
