#! /usr/bin/ruby
# usage : ruby script [option argu]
# -i filename  the trans_matrix file
# -e filename  the end state set of the DFA
# -o filename  the outputfile
# -l the limit of the length of the trace
# -a whether or not consider the accepted state
# milannic liu 2013

timestamp = Time.new.strftime("%Y-%m-%d-%H-%M")
trans_matrix_file = "../resource/5_12"
#end_state_set = "../resource/bro217_end_state"
output_file = "../../output_link/oTrace/#{timestamp}"
option = 0
string_len = 0
accepted_states = 0
accepted_states_list = []


if (arg_index = ARGV.index("-l")) != nil
	if	(ARGV[arg_index+1] =~ /^\d+$/) != nil
		option = 1
		string_len = ARGV[arg_index+1].to_i
		output_file += "l"
	end
end

if (arg_index = ARGV.index("-a")) != nil
	accepted_states = 1	
	output_file += "a"
end


if (arg_index = ARGV.index("-i")) != nil
	if	(ARGV[arg_index+1] =~ /^-/) == nil && ARGV[arg_index+1] != nil
		trans_matrix_file = ARGV[arg_index+1]
	end
end


if (arg_index = ARGV.index("-o")) != nil
	if	(ARGV[arg_index+1] =~ /^-/) == nil && ARGV[arg_index+1] != nil
		output_file = ARGV[arg_index+1]
	end
end


if (arg_index = ARGV.index("-e")) != nil
	if	(ARGV[arg_index+1] =~ /^-/) == nil && ARGV[arg_index+1] != nil
		end_state_set= ARGV[arg_index+1]
	end
end
=begin
	p end_state_set
	p output_file
	p trans_matrix_file
	p accepted_states
	p option
=end
total_state = 0	
trans = []

file = File.open(trans_matrix_file,'r')
total_state=file.gets.chop!.to_i
p total_state
#$stdin.gets
total_state.times do |index|
    #p index
	line = file.gets
	words = line.split("\s")
	words.uniq!
	words.map!{|word|
			word.to_i
		}
	trans<<words
end

if accepted_states == 1 
	while line = file.gets
		line.chop!
		#p line
		words = line.delete("\t").split(":")
		#p words
		accepted_states_list << words[0].to_i
		#$stdin.gets
	end
end

#p accepted_states_list
file.close

#forbid the DFA jump back to the initial state
trans.each{|trans_element|
		trans_element.delete(0)
}

=begin
if accepted_states == 1
	end_state = File.new(end_state_set,"r")
	while line = end_state.gets
		end_state_index = line.chop.to_i
		trans.each{|trans_element|
			trans_element.delete(end_state_index)
		}
	end
	end_state.close
end
=end

#sort the whole trans_matrix, to make those states who have most next states stands first

trans.each{|trans_element|
	trans_element.sort_by!{|a|
		if accepted_states_list.include?(a) == true
			weight = 10
		else
			weight = 0
		end
		trans[a].count+weight
	}.reverse!
}



output = File.open(output_file,"w+:ASCII-8BIT")
endl = "\n"
rand_factor = 0.2

#outside loop, copy every transition matrix to a new temp one to be modified during tranverse
###################################################################
while true
	
	point = 0
	point2 = 0
	trans_clone = []
	trans.each{|trans_element|
			trans_clone<<trans_element.clone
	}

	if option == 1
		output<<"[0"
		(string_len-1).times{
			index = (rand_factor*rand()*trans_clone[point].length).floor
			point2 = trans_clone[point][index]

			trans_clone.each{|ele|
				ele.delete(point2)
			}

			if trans_clone[point2].empty?
				#p "this is the index #{point2}"
				trans_clone[point2] = trans[point2].clone
				#p trans_clone[point2]
			end

			output<<','<<point2
			point = point2
		}
		output<<"]"<<endl
		output<<string_len<<endl
	else
		track = [0]
		while !(trans_clone[point].empty?)
			index = (rand_factor*rand()*trans_clone[point].length).floor
			point2 = trans_clone[point][index]

			trans_clone.each{|ele|
				ele.delete(point2)
			}

			track<<point2
			point = point2
		end
		output<<track<<endl
		output<<track.length<<endl
	end
end
output.close

