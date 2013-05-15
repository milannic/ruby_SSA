#! /usr/bin/ruby
# usage: ruby script [option argu]
# -o filename     the output file
# -l number       the total length of a certain trace
# -t tracefile    the previous tracefile
# milannic liu 2013
# delinate the structure of a dfa state
# every dfa state is a array whose first element(with the identifer 0) is the current state number while the rest elements are the segments current trace have matched previously
# state[ele0,ele1,ele2]




def get_max(value_table)
	copy_table = []
	value_table.each do |value|
		copy_table<<value.clone
	end
	copy_table.sort!{|value1,value2|
		value1[1] <=> value2[1]
	}.reverse!
	return copy_table[0][0]
end

def cal_value(trans_matrix,match_matrix,dfa_record,dfa_trace,rule_table,value_table,tsi_matrix,weight_table)
	(0..255).each do |ascii_code|
		temp_value = 0
		new_state = [[],[],[]]
		new_activate_state = [[],[],[]]
		new_dfa_0_reg = []
		new_current_state = [[],[],[]]
		dfa_record.each_with_index do |single_dfa,dfa_index|
			single_dfa.each do |single_state|
				next_state = trans_matrix[dfa_index][single_state[0]][ascii_code]
				if next_state == 49
					temp_value -= 100
				end
				if new_current_state[dfa_index].include?(next_state) == true
					temp_value -= 10 
				else
					new_current_state[dfa_index] << next_state
				end
				if match_matrix[dfa_index][next_state][0] == 1  #dead state
					temp_value -= 3
				else 
					temp_value += weight_table[dfa_index][next_state]
					if dfa_trace[dfa_index].include?(next_state) == false
						if new_state[dfa_index].include?(next_state) ==false
							new_state[dfa_index] << next_state
							temp_value +=  5
						end
					end
					match_matrix[dfa_index][next_state][1..match_matrix[dfa_index][next_state].length()-1].each do |reg_num|			
						if	single_state[1..single_state.length()-1].include?(reg_num) == false
							temp_value += 5
						end
						if single_state[1..single_state.length()-1].include?(tsi_matrix[reg_num-1][0]) == true
							if tsi_matrix[reg_num-1][2] == 0
								if rule_table[reg_num-1] == 0 
									if new_dfa_0_reg.include?(reg_num) == false
										if tsi_matrix[reg_num-1][1] == 0
											new_dfa_0_reg << reg_num
										else
											temp_value += 100
										end
										if new_activate_state[tsi_matrix[reg_num-1][1]].length() == 0
											temp_value += 10
											new_activate_state[tsi_matrix[reg_num-1][1]] << tsi_matrix[reg_num-1][0]
										elsif new_activate_state[tsi_matrix[reg_num-1][1]].include?(tsi_matrix[reg_num-1][0]) == false
											temp_value += 5
											new_activate_state[tsi_matrix[reg_num-1][1]] << tsi_matrix[reg_num-1][0]
										end
									end
								end
							end
						end
					end
				end
			end
		end
		value_table[ascii_code][1] =  (temp_value*((0.7+0.3*rand())).to_f)
		#value_table[ascii_code][1] =  temp_value
	end
end


def get_next(trans_matrix,match_matrix,dfa_record,dfa_trace,rule_table,tsi_matrix,tempchar)
	#p "start"
	#p dfa_record
	new_activate_state = [[],[],[]]
	availble_state = [[],[],[]]
	hash_table = [Hash.new([]),Hash.new([]),Hash.new([])]
	dfa_record.each_with_index do |single_dfa,dfa_index|
		single_dfa.each do |single_state|
			single_state[0] = trans_matrix[dfa_index][single_state[0]][tempchar]
			dfa_trace[dfa_index] << single_state[0]
			new_reg = Array.new()
			if match_matrix[dfa_index][single_state[0]][0] == 1 # dead state
				single_state[0] = -1
			else
				match_matrix[dfa_index][single_state[0]][1..match_matrix[dfa_index][single_state[0]].length()-1].each do |reg_num|
					#single_state << reg_num
					new_reg<<reg_num
					if tsi_matrix[reg_num-1][2] == 0 # a middle segment
						if single_state[1..single_state.length()-1].include?(tsi_matrix[reg_num-1][0]) == true #previous matched segment found 
							#p single_state
							#p "new state"
							#p tsi_matrix[reg_num-1][1]
							#k =	$stdin.gets
							if rule_table[reg_num-1] == 0  # rule_table is still available
								#p reg_num
								new_activate_state[tsi_matrix[reg_num-1][1]]<< reg_num
								if tsi_matrix[reg_num-1][1] == 0
									rule_table[reg_num-1] = 1
								end
							end
						end
					end
				end
			end
			new_reg.each do |reg_num|
				single_state<<reg_num
			end
		end
	end
	#p "single_state"
	dfa_record.each_with_index do |single_dfa,dfa_index|
		single_dfa.each do |single_state|
			#p single_state
			if single_state[0] != -1 # not a dead state
				availble_state[dfa_index] << single_state[0]
				k = single_state[0]
				#p "hash_table"
				#p hash_table[dfa_index][k]
				temp_array = hash_table[dfa_index][single_state[0]].clone
				single_state[1..single_state.length()-1].each do |ele|
					temp_array << ele
				end
				hash_table[dfa_index][single_state[0]] = temp_array.clone
				#p temp_array
			end
		end
	end
	#p new_activate_state
	new_activate_state.each_with_index do |single_dfa,dfa_index|
		if single_dfa.length() != 0
			availble_state[dfa_index] << 0
			temp_array = [0]
			single_dfa.each do |ele|
				temp_array << ele
			end
			hash_table[dfa_index][0] = temp_array 
		end
	end
	#p "middle"
	dfa_record.each_with_index do |single_dfa,dfa_index| 
		dfa_record[dfa_index] = []
		availble_state[dfa_index].uniq.each do |ele|
			array = [ele]
			hash_table[dfa_index][ele].uniq.each do |pre_seg|
				array << pre_seg
			end
			dfa_record[dfa_index] << array
		end
	end
	dfa_trace.each do |ele|
		ele.uniq!
	end
	#p dfa_record
	#p "end"
end



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

rule_table = []
reg_total = tsi_matrix.length()
reg_total.times{
	rule_table<<0
}


key_reg = []
key_state = [Array.new(),Array.new(),Array.new()]
tsi_matrix.each_with_index do |entry,index|
	if (entry[0] == 0) && (entry[1] != 0) && (entry[2]<=0)
		key_reg << (index+1)
	end
end

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
		#p entry
		flag_matrix[outter_index][entry] = 1
		weight_table[outter_index][entry] = 0
		loop_control[outter_index].delete(entry)
		array[outter_index]<<entry
	end
end



level = [0,0,0]

(0..2).each do |dfa_selector|
	if array[dfa_selector].length() != 0
		#p dfa_selector
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
		entry = (level[index] - entry)*2
	end
end







# remember -1 
# the regex number in the file starts with 1 while those in array starts with 0
output_file_index = File.new("#{output_file}/index","w+")
count = 0
while true
#while count == 0
	frequency = 0
	output_file_variable= File.new("#{output_file}/#{count}","w+:ASCII-8BIT")
	#dfa_record = [[[2587,0]],[],[]]  # record current state sequence of the DFA
	dfa_record = [[[0,0]],[0,0],[]]  # record current state sequence of the DFA
	dfa_trace = [[],[],[]]   # record every visited state for each DFA
	ascii_trace = ""         # record the ascii trace that need to be written in the file
	tempchar = 0
	rule_table.map!{|a| a=0 }

	string_len.times do |index|
		cal_value(trans_matrix,match_matrix,dfa_record,dfa_trace,rule_table,value_table,tsi_matrix,weight_table)
		tempchar = get_max(value_table)
		#p tempchar
		ascii_trace << tempchar.chr
		get_next(trans_matrix,match_matrix,dfa_record,dfa_trace,rule_table,tsi_matrix,tempchar)
		#p dfa_record
		dfa_record.each do |single_dfa|
			frequency += single_dfa.length()
		end
	end
	output_file_variable<<ascii_trace
	output_file_variable.close()
	count += 1
	frequency = (frequency.to_f/string_len.to_f).to_f
	output_file_index<< "#{count} : #{frequency}\n"
	output_file_index.flush()
end
output_file_index.close()

