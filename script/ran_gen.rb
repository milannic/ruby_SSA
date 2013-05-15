para = 800
count_time = 10
count_time.times{|index|
	output = File.new("#{para}_#{index}","w+:ASCII-8BIT")
	string = ""
	para.times{
		string<<(rand()*255).floor.chr
	}
	output<<string
	output.close
}
