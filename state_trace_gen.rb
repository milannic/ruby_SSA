#! /usr/bin/ruby
# usage: ruby filename arg[0] arg[1] arg[2] arg[3]
# arg[0] is the filename of the transition matrix whose first line is the total number of states
# arg[1] is the filename of the output file
# arg[2] is the filename of the end_state_file all the end states included in the file should be deleted 
#
# eg: ruby rand_sort_modified_version.rb test result record
#
#
# milannic liu 2013

#rand_index function to be modified further



#calculate the basic information of this DFA to know which state has the most transitions to different states 
trans = []
file = File.open(ARGV[0])
while line = file.gets
	words = line.split("\s")
	words.uniq!
	words.map!{|word|
			word.to_i
		}
	trans<<words
end
file.close
count = trans.shift.shift
#forbid the DFA jump back to the initial state
trans.each{|trans_element|
		trans_element.delete(0)
}


end_state = File.new(ARGV[1],"r+")
while line = end_state.gets
	end_state_index = line.chop.to_i
	trans.each{|trans_element|
		trans_element.delete(end_state_index)
	}
end
end_state.close

#sort the whole trans_matrix, to make those states who have most next states stands first

trans.each{|trans_element|
	trans_element.sort!{|a,b|
		trans[a].count <=> trans[b].count
	}.reverse!
}

output = File.open(ARGV[2],"a+")
endl = "\n"
rand_factor = 0.2
string_len = ARGV[3].to_i
#outside loop, copy every transition matrix to a new temp one to be modified during tranverse
###################################################################
while true
	
	point = 0
	point2 = 0
	trans_clone = []
	trans.each{|trans_element|
			trans_clone<<trans_element.clone
	}
	output<<0	
	string_len.times{
		index = (rand_factor*rand()*trans_clone[point].length).floor
		point2 = trans_clone[point][index]

		trans_clone.each{|ele|
			ele.delete(point2)
		}

		if trans_clone[point2].empty?
			trans_clone[point2] = trans[point2].clone
		end

		output<<','<<point2
		point = point2
	}
	output<<endl	
end
output.close

