#! /usr/bin/ruby
# usage: ruby script [option argu]
# -o filename     the output file
# -l number       the total length of a certain trace
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
		value1[1] <==> value2[1]
	}.reverse!
	return copy_table[0][0]
end

def cal_value(trans_matrix,match_matrix,dfa_record,dfa_trace,rule_table,value_table)
	(0..255).each do |ascii_code|
		temp_value = 0
		new_state = [[],[],[]]
		new_activate_state = [[],[],[]]
		new_dfa_0_reg = []
		dfa_record.each_with_index do |single_dfa,dfa_index|
			single_dfa.each do |single_state|
				next_state = trans_matrix[dfa_index][single_state[0]][ascii_code]
				if match_matrix[dfa_index][next_state][0] == 1  #dead state
					temp_value -= 10
				else 
					if dfa_trace[dfa_index].include?(next_state) == false
						if new_state[dfa_index].include?(next_state) ==false
							new_state[dfa_index] << next_state
							temp_value += 3 
						end
					end
					match_matrix[dfa_index][next_state][1..match_matrix[dfa_index][next_state].length()-1].each do |reg_num|
						if single_state[1..single_state.length()-1].include?(tsi_matrix[reg_num-1][0]) == true
							if tsi_matrix[reg_num-1][2] == 0
								if rule_table[reg_num-1] == 0 
									if new_dfa_0_reg.include?(reg_num) == false
										if tsi_matrix[reg_num-1][1] == 0
											new_dfa_0_reg << reg_num
										end
										if new_activate_state[tsi_matrix[reg_num-1][1]].length() == 0
											temp_value += 10
											new_activate_state[tsi_matrix[reg_num-1][1]] << tsi_matrix[reg_num-1][0]
										elsif new_activate_state[tsi_matrix[reg_num-1][1]].include?(tsi_matrix[reg_num-1][0]) == false
											temp_value += 1
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
		value_table[ascii_code] = (temp_value*((0.8)*rand())).ceil
	end
end


def get_next(trans_matrix,match_matrix,dfa_record,dfa_trace,rule_table,tempchar)
	new_activate_state = [[],[],[]]
	availble_state = [[],[],[]]
	hash_table = [Hash.new([]),Hash.new([]),Hash.new([])]
	dfa_record.each_with_index do |single_dfa,dfa_index|
		single_dfa.each do |single_state|
			single_state[0] = trans_matrix[dfa_index][single_state[0]][tempchar]
			dfa_trace[dfa_index] << single_state[0]
			if match_matrix[dfa_index][single_state[0]][0] == 1 # dead state
				single_state[0] = -1
			else
				match_matrix[dfa_index][single_state][1..matched[dfa_index][single_state].length()-1].each do |reg_num|
					single_state << reg_num
					if tsi_matrix[reg_num-1][2] == 0 # a middle segment
						if single_state[1..single_state.length()-1].include?(tsi_matrix[reg_num-1][0]) == true #previous matched segment found
							if rule_table[reg_num-1] == 0  # rule_table is still available
								new_activate_state[tsi_matrix[reg_num-1][1]]<< reg_num
								if tsi_matrix[reg_num-1][0] == 0
									rule_table[reg_num-1] = 1
								end
							end
						end
					end
				end
			end
		end
	end
	dfa_record.each_with_index do |single_dfa,dfa_index|
		single_dfa.each do |single_state|
			if single_state[0] != -1 # not a dead state
				availble_state[dfa_index] << single_state[0]
				single_state[1..single_state.length()-1].each do |ele|
					hash_table[dfa_index][single_state[0]] << ele
				end
			end
		end
	end
	new_activate_state.each_with_index do |single_dfa,dfa_index|
		availble_state[dfa_index] << 0
		single_dfa.each do |ele|
			hash_table[dfa_index][0] << ele
		end
	end
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
end



timestamp = Time.new.strftime("%Y-%m-%d-%H-%M")
trans_matrix_file_1 = "../resource/DFA1_TRANS.data"
trans_matrix_file_2 = "../resource/DFA2_TRANS.data"
trans_matrix_file_3 = "../resource/DFA3_TRANS.data"
match_matrix_file_1 = "../resource/DFA1_MATCH.data"
match_matrix_file_2 = "../resource/DFA2_MATCH.data"
match_matrix_file_3 = "../resource/DFA3_MATCH.data"
tsi_file = "../resource/TSI.data"
output_file = "../../output_link/oTrace/#{timestamp}"
string_len = 2000
reg_total = 0


if (arg_index = ARGV.index("-l")) != nil
	if	(ARGV[arg_index+1] =~ /^\d+$/) != nil
		option = 1
		string_len = ARGV[arg_index+1].to_i
		output_file += "l"
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
dfa_state_total << file1.gets.chop!.to_i

while line = file1.gets
	words = line.split("\s")
	words.map! do |word|
		word.to_i
	end
	trans_matrix[0]<<words
end

file1.close



file2 = File.new(trans_matrix_file_2,'r+') 
dfa_state_total << file2.gets.chop!.to_i

while line = file2.gets
	words = line.split("\s")
	words.map! do |word|
		word.to_i
	end
	trans_matrix[1]<<words
end

file2.close


file3 = File.new(trans_matrix_file_3,'r+') 
dfa_state_total << file3.gets.chop!.to_i

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
reg_total = file7.gets.chop.split("\s")[0].to_i

while line = file7.gets
	words = line.split("\s")
	words.map! do |word|
		word.to_i
	end
	tsi_matrix<<words	
end

file7.close

rule_table = []
reg_total.times{
	rule_table<<0
}
# remember -1 
# the regex number in the file starts with 1 while those in array starts with 0
count = 0


while true
	output_file_variable= File.new("#{output_file}_#{count}","w+:ASCII-8BIT")
	dfa_record = [[],[],[]]  # record current state sequence of the DFA
	dfa_trace = [[],[],[]]   # record every visited state for each DFA
	ascii_trace = ""         # record the ascii trace that need to be written in the file
	tempchar = 0
	rule_table.map!{|a| a=0 }

	string_len.times do |index|
		cal_value(trans_matrix,match_matrix,dfa_record,dfa_trace,rule_table,value_table)
		p value_table
		tempchar = get_max(value_table)
		ascii_trace << tempchar.chr
		get_next(trans_matrix,match_matrix,dfa_record,dfa_trace,rule_table,tempchar)
	end
	output_file_variable<<ascii_trace
	output_file.close()
	count += 1
end


