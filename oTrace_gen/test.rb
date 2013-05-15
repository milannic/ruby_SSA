#! /usr/bin/ruby


file = File.new("./7","r+:ASCII-8bit")

while a = file.getc
	p "#{a}:#{a.ord}"
end
