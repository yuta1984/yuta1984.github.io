Dir.glob("*.jpg") do |path|
  `convert -geometry 10% #{path} #{path.sub('.','.min.')}`
end
