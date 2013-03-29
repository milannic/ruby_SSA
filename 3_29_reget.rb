#! /usr/bin/ruby
#usage: this rb script is used to produce random string sequence(ascii) from the sequence of state
#ruby filename arg[0] arg[1] arg[2]


time_start = Time.now()
endl = '\n'
if File.exist?(ARGV[0])
	record = File.open(ARGV[0],'r+')
	length = record.gets.chop.to_i
	state_array = record.gets.strip.delete('[').delete(']').split(",")
	state_array.map!{|ele|
		ele.to_i
	}
	record.close
=begin
	p state_array
	state_array.each{|ele|
		p "#{ele} + #{ele.succ}"
	}
=end
else
	exit
end

if File.exist?(ARGV[1])
	trans_file= File.open(ARGV[1],'r+')
	trans_matrix = []
	while line = trans_file.gets
		trans_vector = line.split("\s")
		trans_vector.map!{|state|
			state.to_i
		}
	#p trans_vector
	trans_matrix<<trans_vector
	end
	trans_file.close
else
	exit
end
trans_matrix.shift
string_per_line = ""
output_file = File.open(ARGV[2],'a+')
#output_file.puts 69.chr
#output_file.close
while true
	state_array.each_with_index{|ele,index_ele|
		if index_ele != state_array.length-1
			temp_vector = trans_matrix[ele]
			#p temp_vector
			temp_selector = []
			temp_vector.each_with_index{|value,index|
				if value ==	state_array[index_ele+1] 
					temp_selector<<index
					#p state_array[index_ele+1] 
					#p index
				end
			}
			#p temp_selector.length
			selector = temp_selector[(rand()*temp_selector.length).floor]
			string_per_line<<(selector.chr)
			#p string_per_line
		end
	}
	#p string_per_line
	output_file<<string_per_line<<endl
	output_file.flush()
	string_per_line = ""
	#string_h = getch
end
output_file.close

