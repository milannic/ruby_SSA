def get_the_index(length)
	rand_num = rand()
	if length >= 9
		case rand_num
			when 0..0.3
				return 0
			when 0.3..0.5
				return 1
			when 0.5..0.65
				return 2
			when 0.65..0.75
				return 3
			when 0.75..0.8
				return 4
			when 0.8..0.85
				return 5
			when 0.85..0.9
				return 6
			when 0.9..0.95
				return 7
			else
				return 8
		end
	else 
		return 0
	end
end

=begin
a = [0,1,2,3,4,5,6,7,8]
count = Hash.new(0)
 
1000000.times{
	temp = get_the_index
    count[a[temp]] = count[a[temp]]+1
}#count[a[temp]] = count[a[temp]]+1}

count.sort{|a,b|
	a[1] <=> b[1]
}.each{|key,value|
	print "#{key} : #{value} \n"
}

=end

p time_start = Time.now()
#calculate the words count
trans = []
max_hop = 0
max_find = []
#count = Hash.new(0)
file = File.open(ARGV[0])
while line = file.gets
	words = line.split("\s")
	words.uniq!
	words.map!{|word|
			word.to_i
		}
	#words.sort!
	if max_hop < words.count
		max_hop = words.count
		max_find = words
	end	
	trans<<words
	#words.each{|word|
	#	count[word] += 1
	#}
end
#p ARGV[1]
count = trans.shift.shift
#p test
#p max_hop
#p max_find
#p trans.index(max_find)
trans.each{|trans_element|
		trans_element.delete(0)
	}
total = []
#sort the whole trans_matrix, to make those states who have most next states stands first
trans.each{|trans_element|
	trans_element.sort!{|a,b|
		trans[a].count <=> trans[b].count
	}.reverse!
}



#p trans
###################################################################
(ARGV[2].to_i).times{
	#initialize
	filter = 0
	point = 0
	point2 = 0
	track = [0]
	trans_clone = []
	trans.each{|trans_element|
			trans_clone<<trans_element.clone
		}
	#p trans_clone
###################################################################
	(ARGV[1].to_i).times{
		unless trans_clone[point].empty?
			#a = trans_clone[point].length
			#b = get_the_index(a)
			#p a
			#p b
			track<<point2 = trans_clone[point][get_the_index(trans_clone[point].length)]
			#track<<point2 = trans_clone[point][b]
			trans_clone.each{|trans_element_clone|
					trans_element_clone.delete(point2)
				}
			filter = filter + 1
			if filter == 5	
				trans_clone.each{|trans_element_clone|
					trans_element_clone.sort!{|a,b|
					trans_clone[a].count <=> trans_clone[b].count
					}.reverse!
				}
					filter = 0
			end
			point = point2
			#p test
		else
		break
		end
	}
###################################################################
	#total << track unless track.length < ARGV[1].to_i
	#p track
	total << track
}

total.each{|ele|
	p ele
	p ele.length
}
#p total[0].length
=begin
result= Hash.new(0)
total.each{|array|
		result[array] = array.length 
	}

result.sort{|a,b|
	a[1] <=> b[1]
}.each{|key,value|
	print "#{key}: #{value}\n"
}
=end
p time_end = Time.now()-time_start
