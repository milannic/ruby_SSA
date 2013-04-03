#! /usr/bin/ruby
#-i  # the filename of the import file
#-d  # delete mode
#-s  # swap mode
#-c  # change mode
#-m  # mix_mode
#-f  # the factor of the distrub
#-r  # the repeated time of a single trace
#-o  # the output directory


random_delete = Proc.new{|string_original|
	if string_original.length == 0
		return ""
	end
	position = (rand()*string_original.length).floor
	if position == 0
		string_original = string_original[1..string_original.length-1]
	elsif position == string_original.length 
		string_original = string_original[0..string_original.length-2]
	else
		string_original = string_original[0..position-1]+string_original[position+1..string_original.length-1]
	end
	string_original
}

random_swap = Proc.new{|string_original|
	if string_original.length == 0
		return ""
	end
	position1 = position2 = 0
	while position1 == position2
		position1 = (rand()*string_original.length).floor
		position2 = (rand()*string_original.length).floor
	end
	temp = string_original[position1]
	string_original[position1] = string_original[position2]
	string_original[position2] = temp
	string_original
}

random_change = Proc.new{|string_original|
	if string_original.length == 0
		return ""
	end
	position = (rand()*string_original.length).floor
	range_factor = (rand()*8).floor
	string_original[position] = (string_original[position].ord^(1<<range_factor)).chr
	string_original
}

endl = '\n'
repeated_times = 10000
disturb_factor = 0.01

mix_flag = 1
delete_flag = 0
change_flag = 0
swap_flag = 0

trace_file_path = ""
output_directory = ""
timestamp = Time.new.strftime("%Y-%m-%d-%H-%M")

if (arg_index = ARGV.index("-i")) != nil
	if	(ARGV[arg_index+1] =~ /^-/) == nil && ARGV[arg_index+1] != nil
		trace_file_path= ARGV[arg_index+1]		
	else
		p "no input file"
		exit
	end
end

if (arg_index = ARGV.index("-m")) != nil
	mix_flag = 1
else
	if (arg_index = ARGV.index("-d")) != nil
		delete_flag = 1
		mix_flag = 0
	end

	if (arg_index = ARGV.index("-s")) != nil
		if(delete_flag == 1)
			p "only one mode can be set without mix mode"
			exit
		else
			swap_flag = 1
			mix_flag = 0
		end
	end

	if (arg_index = ARGV.index("-c")) != nil
		if((delete_flag == 1) || (swap_flag == 1))
			p "only one mode can be set without mix mode"
			exit
		else
			change_flag = 1
			mix_flag = 0
		end
	end
end

=begin
if (mix_flag+delete_flag+swap_flag+change_flag) == 0
	change_flag = 1
end
=end
p ARGV
if (arg_index = ARGV.index("-f")) != nil
	if	(ARGV[arg_index+1] =~ /^\d+(\.\d+)?$/) != nil
		disturb_factor = ARGV[arg_index+1].to_i
		if (point_index = ARGV[arg_index+1].index('.')) != nil
			float_part = ARGV[arg_index+1][point_index+1,ARGV[arg_index+1].length-1].to_i
			(ARGV[arg_index+1].length-1-point_index).times{
				float_part = float_part*0.1
			}
		#p ARGV[arg_index+1]
		disturb_factor = disturb_factor+float_part
		#p disturb_factor
		end
	end
end

if (arg_index = ARGV.index("-r")) != nil
	if	(ARGV[arg_index+1] =~ /^\d+$/) != nil
		repeated_times = ARGV[arg_index+1].to_i
	end
end

if (arg_index = ARGV.index("-o")) != nil
	if	(ARGV[arg_index+1] =~ /^-/) == nil && ARGV[arg_index+1] != nil
		output_directory = ARGV[arg_index+1]
	end
else
	test_index =  trace_file_path.rindex('/')
	if test_index != nil
		output_directory = ".#{trace_file_path[test_index..trace_file_path.length-1]}_"
	else
		output_directory = "./#{trace_file_path}_"
	end
end


output_directory += timestamp

if delete_flag == 1
	output_directory += '_d'
elsif swap_flag == 1
	output_directory += '_s'
elsif change_flag == 1
	output_directory += '_c'
else
	output_directory += '_m'
end

output_directory += "_#{disturb_factor}"

if(!File.exist?(output_directory))
	Dir.mkdir(output_directory)
end


if File.exist?(trace_file_path)
	string_original = ""
	string_file_original = File.open(trace_file_path,'r+:ASCII-8BIT')
	while line = string_file_original.gets
		string_original = string_original+line
	end
	#p string_original.length
	disturb_times = (disturb_factor * string_original.length).ceil
	mode = 0
	proc_pointer = nil
	if mix_flag == 1
		repeated_times.times{|index|
                        string_clone = string_original.clone
			output_file = File.open("#{output_directory}/#{index}","w+:ASCII-8BIT")
			disturb_times.times{
				mode = (rand()*3).floor
				case mode
				when 0
					proc_pointer = random_delete
				when 1
					proc_pointer = random_swap
				when 2
					proc_pointer = random_change
				end
				string_clone = proc_pointer.call(string_clone)
			}	
			output_file<<string_clone
			output_file.close
		}
	else
		if delete_flag == 1
			proc_pointer = random_delete
		elsif swap_flag == 1
			proc_pointer = random_swap
		else
			proc_pointer = random_change
		end
		repeated_times.times{|index|
			string_clone = string_original.clone
			output_file = File.open("#{output_directory}/#{index}","w+:ASCII-8BIT")
			disturb_times.times{
				string_clone = proc_pointer.call(string_clone)
			}
			output_file<<string_clone
			output_file.close
		}
	end
else
	exit
end
