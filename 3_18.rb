#! /usr/bin/ruby
# usage: ruby filename arg[0] arg[1]
# arg[0] is the filename of the transition matrix whose first line is the total number of states
# arg[1] is the filename of the output file
# eg: ruby rand_sort_modified_version.rb test result
#
# milannic liu 2013

#rand_index function to be modified further
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



p time_start = Time.now()
#calculate the basic information of this DFA to know which state has the most transitions to different states 
trans = []
max_hop = 0
max_find = []
file = File.open(ARGV[0])
#read the transit_matrix , combine those transitions pointing to the same state
while line = file.gets
	words = line.split("\s")
	words.uniq!
	words.map!{|word|
			word.to_i
		}
	if max_hop < words.count
		max_hop = words.count
		max_find = words
	end	
	trans<<words
end
file.close
count = trans.shift.shift
#forbid the DFA jump back to the initial state
trans.each{|trans_element|
		trans_element.delete(0)
	}

#sort the whole trans_matrix, to make those states who have most next states stands first
trans.each{|trans_element|
	trans_element.sort!{|a,b|
		trans[a].count <=> trans[b].count
	}.reverse!
}

output = File.open(ARGV[1],"a+")
endl = "\n"

#outside loop, copy every transition matrix to a new temp one to be modified during tranverse
###################################################################
while true
	#initialize
	#use to control the frequency when to recalculate the transition matrix  
	filter = 0
	point = 0
	point2 = 0
	track = [0]
	trans_clone = []
	trans.each{|trans_element|
			trans_clone<<trans_element.clone
	}
#inside loop, simulate every transition in the DFA
###################################################################
		#when the transition matrix in current state is empty, it means that this simulation has ended
	while !trans_clone[point].empty?
			#get next state
		track<<point2 = trans_clone[point][get_the_index(trans_clone[point].length)]
			#delete next state in transition matrix in all states
		trans_clone.each{|trans_element_clone|
				trans_element_clone.delete(point2)
		}
			#use to control the frequency of the recalculate the transition matrix 
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
		#p track
	end
	#p "first one"
	output<<track<<endl
	output<<track.length<<endl
	#output<<Time.now()-time_start<<endl
	output.flush()
###################################################################
end
output.close