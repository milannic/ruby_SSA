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
p max_hop
p max_find
p trans.index(max_find)
trans.each{|trans_element|
		trans_element.delete(0)
	}
total = []
#p trans
###################################################################
(ARGV[2].to_i).times{
	#initialize
	point = 0
	point2 = 0
	track = [0]
	trans_clone = []
	trans.each{|trans_element|
			trans_clone<<trans_element.shuffle	
		}
	#p trans
###################################################################
	(ARGV[1].to_i).times{
		unless trans_clone[point].empty?
			track<<point2 = trans_clone[point][0]
			trans_clone.each{|trans_element_clone|
					trans_element_clone.delete(point2)
				}
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
#total.uniq!
#p total
#p total[0].length
#=begin
result= Hash.new(0)
total.each{|array|
		result[array] = array.length 
	}

result.sort{|a,b|
	a[1] <=> b[1]
}.each{|key,value|
	print "#{key}: #{value}\n"
}
#=end
p time_end = Time.now()-time_start
