dir = Dir.open('/usr/bin')
while name = dir.read
	p name
end
dir.close
