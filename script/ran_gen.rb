para = 623
output = File.new("623","w+:ASCII-8BIT")
string = ""
para.times{
	string<<(rand()*255).floor.chr
}
output<<string
output.close
