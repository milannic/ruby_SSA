p time_start = Time.now()
#calculate the words count
state_number = 0
count_hash = Hash.new(0)
trans_hash = Hash.new(0)
file = File.open(ARGV[0])
line = file.gets
while line = file.gets
	words = line.split("\s")
	words.uniq!
	words.map!{|word|
			word.to_i
	}
	if count_hash[words] == 0
		count_hash[words] = [words.count,state_number]
	else
		count_hash[words].push(state_number)
	end
	state_number = state_number + 1
end
count_hash.each{|key,value|
	#p value
	#p value.length-1
	#p value[0]
	trans_hash[value[0]] = trans_hash[value[0]]+value.length-1
	#p trans_hash[value[0]]
}
#=begin
trans_hash.sort{|a,b|
	a[1] <=> b[1]
}.each{|key,value|
	print "#{key}\n"
	print "#{key}: #{value}\n"
}
#=end
p time_end = Time.now()-time_start
