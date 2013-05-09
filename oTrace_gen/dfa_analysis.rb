#! /usr/bin/ruby
# usage: ruby script [option argu]
# -o filename     the output file
# -l number       the total length of a certain trace
# milannic liu 2013
# delinate the structure of a dfa state
# every dfa state is a array whose first element(with the identifer 0) is the current state number while the rest elements are the segments current trace have matched previously
# state[ele0,ele1,ele2]




timestamp = Time.new.strftime("%Y-%m-%d-%H-%M")
trans_matrix_file_1 = "../resource/DFA1_TRANS.data"
trans_matrix_file_2 = "../resource/DFA2_TRANS.data"
trans_matrix_file_3 = "../resource/DFA3_TRANS.data"
match_matrix_file_1 = "../resource/DFA1_MATCH.data"
match_matrix_file_2 = "../resource/DFA2_MATCH.data"
match_matrix_file_3 = "../resource/DFA3_MATCH.data"
tsi_file = "../resource/TSI.data"
#output_file = "../../output_link/oTrace/#{timestamp}"
output_file = "."
string_len = 200
reg_total = 0


if (arg_index = ARGV.index("-l")) != nil
	if	(ARGV[arg_index+1] =~ /^\d+$/) != nil
		option = 1
		string_len = ARGV[arg_index+1].to_i
	end
end


if (arg_index = ARGV.index("-o")) != nil
	if	(ARGV[arg_index+1] =~ /^-/) == nil && ARGV[arg_index+1] != nil
		output_file = ARGV[arg_index+1]
	end
end

dfa_state_total = [] 
trans_matrix = [[],[],[]]
match_matrix = [[],[],[]]
tsi_matrix = []
value_table = []
(0..255).each{|index|
	value_table << [index,0]
}

file1 = File.new(trans_matrix_file_1,'r+') 
#dfa_state_total << file1.gets.chop!.to_i

while line = file1.gets
	words = line.split("\s")
	words.map! do |word|
		word.to_i
	end
	trans_matrix[0]<<words
end

file1.close



file2 = File.new(trans_matrix_file_2,'r+') 
#dfa_state_total << file2.gets.chop!.to_i

while line = file2.gets
	words = line.split("\s")
	words.map! do |word|
		word.to_i
	end
	trans_matrix[1]<<words
end

file2.close


file3 = File.new(trans_matrix_file_3,'r+') 
#dfa_state_total << file3.gets.chop!.to_i

while line = file3.gets
	words = line.split("\s")
	words.map! do |word|
		word.to_i
	end
	trans_matrix[2]<<words
end

file3.close


file4 = File.new(match_matrix_file_1,'r+') 

while line = file4.gets
	words = line.split("\s")
	words.delete('@')
	words.delete_at(1)
	words.map! do |word|
		word.to_i
	end
	match_matrix[0]<<words
end

file4.close


file5 = File.new(match_matrix_file_2,'r+') 

while line = file5.gets
	words = line.split("\s")
	words.delete('@')
	words.delete_at(1)
	words.map! do |word|
		word.to_i
	end
	match_matrix[1]<<words
end
file5.close


file6 = File.new(match_matrix_file_3,'r+') 

while line = file6.gets
	words = line.split("\s")
	words.delete('@')
	words.delete_at(1)
	words.map! do |word|
		word.to_i
	end
	match_matrix[2]<<words
end

file6.close

file7 = File.new(tsi_file,'r+')
#reg_total = file7.gets.chop.split("\s")[0].to_i

while line = file7.gets
	words = line.split("\s")
	words.map! do |word|
		word.to_i
	end
	words[1] -= 1
	tsi_matrix<<words	
end

file7.close

key_reg = []
key_state = [Array.new(),Array.new(),Array.new()]
tsi_matrix.each_with_index do |entry,index|
	if (entry[0] == 0) && (entry[1] != 0) && (entry[2]<=0)
		key_reg << (index+1)
	end
end
p key_reg

match_matrix.each_with_index do |single_dfa,outter_index|
	single_dfa.each_with_index do |entry,inner_index|
		if entry.length() != 1
			key_reg.each do |key_seg|
				if entry[1..entry.length()-1].include?(key_seg) == true
					key_state[outter_index] << inner_index
				end
			end
		end
	end
end

p key_state

array_length = 0
array = [Array.new(),Array.new(),Array.new()]
temp_array = []

flag_matrix = [Array.new(),Array.new(),Array.new()]
weight_table = [Array.new(),Array.new(),Array.new()]
loop_control = [Array.new(),Array.new(),Array.new()]
trans_matrix.each_with_index do |single_dfa,outter_index|
	single_dfa.each_with_index do |entry,inner_index|
		flag_matrix[outter_index] << 0
		weight_table[outter_index] << 0
		loop_control[outter_index] << inner_index
	end
end

key_state.each_with_index do |single_dfa,outter_index|
	single_dfa.each_with_index do |entry|
		p entry
		flag_matrix[outter_index][entry] = 1
		weight_table[outter_index][entry] = 0
		loop_control[outter_index].delete(entry)
		array[outter_index]<<entry
	end
end



level = [0,0,0]

(0..2).each do |dfa_selector|
	if array[dfa_selector].length() != 0
		p dfa_selector
		while loop_control[dfa_selector].length() != 0
			#p loop_control.length()
			#p level
			#$stdin.gets
			temp_array = Array.new()	
			array[dfa_selector].each do |search_state|	
				trans_matrix[dfa_selector].each_with_index do |trans_vector,index|
					if flag_matrix[dfa_selector][index] != 1
						if trans_vector.include?(search_state) == true
							temp_array << index
							weight_table[dfa_selector][index] = level[dfa_selector]
							flag_matrix[dfa_selector][index] = 1
							loop_control[dfa_selector].delete(index)
						end
					end
				end
			end
			array[dfa_selector] = temp_array
			level[dfa_selector] += 1
		end
	end
end


#while 
weight_table.each_with_index do |single_weight_table,index|
	single_weight_table.map! do |entry|
		entry = level[index] - entry
	end
end



# remember -1 
# the regex number in the file starts with 1 while those in array starts with 0
#output_file_index = File.new("#{output_file}/index","w+")
