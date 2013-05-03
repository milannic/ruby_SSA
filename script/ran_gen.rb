para = 623
count_time = 500
count_time.times{|index|
	output = File.new("623_#{index}","w+:ASCII-8BIT")
	string = ""
	para.times{
		string<<(rand()*255).floor.chr
	}
	output<<string
	output.close
}
