#! /usr/bin/ruby
#usage: this rb script is used to produce random string sequence(ascii) from the sequence of state
# -i filename  #the trans_matrix file
# -p filename  #the input_otrace_file 
# -o directory #the outputfile destination
# -l number    #the limit of the length of the trace
# -r number    #the repeat times of each state_sequence
# -c number    #the total number of the traces
# -a           # open the mode of accepted states
# milannic liu 2013


selected_traces = []
required_length = 500 
total_number =	100 
repeated_times = 1 
count_number = 0
sequence_length = 0
endl = '\n'
output_directory = "../../output_link/sTrace/"
trans_matrix_file = "../resource/bro217_trans_matrix"
otrace_file = "../../output_link/oTrace/current"
timestamp = Time.new.strftime("%Y-%m-%d-%H-%M")

if (arg_index = ARGV.index("-l")) != nil
	if	(ARGV[arg_index+1] =~ /^\d+$/) != nil
		required_length= ARGV[arg_index+1].to_i
	end
end


if (arg_index = ARGV.index("-r")) != nil
	if	(ARGV[arg_index+1] =~ /^\d+$/) != nil
		repeated_times= ARGV[arg_index+1].to_i
	end
end

if (arg_index = ARGV.index("-c")) != nil
	if	(ARGV[arg_index+1] =~ /^\d+$/) != nil
		total_number = ARGV[arg_index+1].to_i
	end
end

if (arg_index = ARGV.index("-i")) != nil
	if	(ARGV[arg_index+1] =~ /^-/) == nil && ARGV[arg_index+1] != nil
		trans_matrix_file = ARGV[arg_index+1]
	end
end


if (arg_index = ARGV.index("-o")) != nil
	if	(ARGV[arg_index+1] =~ /^-/) == nil && ARGV[arg_index+1] != nil
		output_directory = ARGV[arg_index+1]
	end
end


if (arg_index = ARGV.index("-p")) != nil
	if	(ARGV[arg_index+1] =~ /^-/) == nil && ARGV[arg_index+1] != nil
		otrace_file= ARGV[arg_index+1]
	end
end

if (arg_index = ARGV.index("-a")) != nil
	output_directory += 'accepted_states/'
	otrace_file += '_accepted_states/'
end

output_directory += timestamp

if(!File.exist?(output_directory))
	Dir.mkdir(output_directory)
end

if File.exist?(otrace_file)
	record = File.open(otrace_file,'r+')
		while ((state_array = record.gets) != nil) && (count_number<total_number)
			if (sequence_length = record.gets) == nil
				p "file corrupted"
				exit
			else
				sequence_length = sequence_length.chop.to_i
			end
			if sequence_length >= required_length
				count_number = count_number +1
				state_array = state_array.chop!.strip.delete('[').delete(']').split(",")
				state_array.map!{|ele|
					ele.to_i
				}
				selected_traces<<state_array
			end
		end
	record.close
else
	exit
end
p selected_traces.length
#test code
=begin
selected_traces.each_with_index{|ele_array,index|
	p "#{index} : #{ele_array}"
}
=end


if File.exist?(trans_matrix_file)
	trans_file= File.open(trans_matrix_file,'r+')
	trans_matrix = []
	while line = trans_file.gets
		trans_vector = line.split("\s")
		trans_vector.map!{|state|
			state.to_i
		}
	trans_matrix<<trans_vector
	end
	trans_file.close
else
	exit
end
trans_matrix.shift


string_per_line = ""
count = 0
selected_traces.each{|state_array_ele|
	repeated_times.times{|times_index|
		output_file = File.open("#{output_directory}/#{state_array_ele.length}_#{count}_#{times_index}","w+:ASCII-8BIT")
		count += 1
		state_array_ele.each_with_index{|ele,index_ele|
			if index_ele != state_array_ele.length-1
				temp_vector = trans_matrix[ele]
				temp_selector = []
				temp_vector.each_with_index{|value,index|
					if value ==	state_array_ele[index_ele+1] 
						temp_selector<<index
					end
				}
				selector = temp_selector[(rand()*temp_selector.length).floor]
				string_per_line<<(selector.chr)
			end
		}
		output_file<<string_per_line
		output_file.close()	
		string_per_line = ""
	}
}
