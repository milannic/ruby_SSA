#! /usr/bin/ruby
# usage: ruby filename arg[0] arg[1] arg[2]
# arg[0] is the filename of the transition matrix whose first line is the total number of states
# arg[1] is the filename of the output file
# arg[2] is the filename of the record file, this file is used to record the deepest trace
# eg: ruby rand_sort_modified_version.rb test result record
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

time_start = Time.now()

trans = []
max_hop = 0
max_find = []
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

trans.each{|trans_element|
		trans_element.delete(0)
	}


trans.each{|trans_element|
	trans_element.sort!{|a,b|
		trans[a].count <=> trans[b].count
	}.reverse!
}

output = File.open(ARGV[1],"a+")
endl = "\n"
rand_factor = 0.2

while true
	point = 0
	point2 = 0
	index = 0
	trans_clone = []
	trans.each{|trans_element|
			trans_clone<<trans_element.clone
	}
	output<<0
	1000000.times{
		index = (rand_factor*rand()*trans_clone[point].length).floor
		point2 = trans_clone[point][index]
		while point2 == point
			index = (rand_factor*rand()*trans_clone[point].length).floor
			p index
			point2 = trans_clone[point][index]
		end
		trans_clone[point].delete_at(index)
		trans_clone[point]<<point2
		output<<'n'<<point2
		point = point2
	}
	output<<endl
end
