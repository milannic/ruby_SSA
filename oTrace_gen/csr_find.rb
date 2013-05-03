#! /usr/bin/ruby
# usage: ruby script [option argu]
# -o filename     the output file
# -l number       the total length of a certain trace
# milannic liu 2013


timestamp = Time.new.strftime("%Y-%m-%d-%H-%M")
trans_matrix_file_1 = "../resource/DFA1_TRANS.data"
trans_matrix_file_2 = "../resource/DFA2_TRANS.data"
trans_matrix_file_3 = "../resource/DFA3_TRANS.data"
match_matrix_file_1 = "../resource/DFA1_MATCH.data"
match_matrix_file_2 = "../resource/DFA2_MATCH.data"
match_matrix_file_3 = "../resource/DFA3_MATCH.data"
dfa0_state_total = 0
dfa1_state_total = 0
dfa2_state_total = 0
tsi_file = "../resource/TSI.data"
output_file = "../../output_link/oTrace/#{timestamp}"
string_len = 800
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

trans_matrix_0 = []
trans_matrix_1 = []
trans_matrix_2 = []


match_matrix_0 = []
match_matrix_1 = []
match_matrix_2 = []

tsi_matrix = []

value_table = []
(0..255).each{|index|
	value_table << [index,0]
}



file1 = File.new(trans_matrix_file_1,'r+') 
dfa0_state_total = file1.gets.chop!.to_i

while line = file1.gets
	words = line.split("\s")
	words.map! do |word|
		word.to_i
	end
	trans_matrix_0<<words
end

file1.close



file2 = File.new(trans_matrix_file_2,'r+') 
dfa1_state_total = file2.gets.chop!.to_i

while line = file2.gets
	words = line.split("\s")
	words.map! do |word|
		word.to_i
	end
	trans_matrix_1<<words
end

file2.close


file3 = File.new(trans_matrix_file_3,'r+') 
dfa2_state_total = file3.gets.chop!.to_i

while line = file3.gets
	words = line.split("\s")
	words.map! do |word|
		word.to_i
	end
	trans_matrix_2<<words
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
	match_matrix_0<<words
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
	match_matrix_1<<words
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
	match_matrix_2<<words
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

def cal_value()
	(0..255).times do |index|	
		temp_value = 0
		temp_next_state = 0
		
		
		if dfa0_trace.length() != 0	
			dfa0_trace.each do |state|
				temp_next_state = trans_matrix_0[state[0]][index]	
				if match_matrix_0[temp_next_state][0] == 1 #dead_state
					temp_value -= 10
				else
					match_matrix_0[temp_next_state][1..match_matrix_0[temp_next_state].length-1].each do |new_state|
						if (state[1..state.length-1].index(tsi_matrix[new_state-1][0]) != nil)  && (tsi_matrix[new_state-1][2] == 0) # activate a new state 0.former record 1. not a final state
							if tsi_matrix[new_state-1][1] != 0
								temp_value += 7
							else
								if rule_table[new_state-1] != 1 
									temp_value += 7
								end
							end
						end
					end
					if dfa0_record.index(temp_next_state) == nil
						temp_value += 5
					end
				end
			end
		end



		if dfa1_trace.length() != 0	
			dfa1_trace.each do |state|
				temp_next_state = trans_matrix_1[state[0]][index]	
				if match_matrix_1[temp_next_state][0] == 1 #dead_state
					temp_value -= 10
				else
					match_matrix_1[temp_next_state][1..match_matrix_1[temp_next_state].length-1].each do |new_state|
						if (state[1..state.length-1].index(tsi_matrix[new_state-1][0]) != nil)  && (tsi_matrix[new_state-1][2] == 0) # activate a new state 0.former record 2. not a final state
							if tsi_matrix[new_state-1][1] != 0
								temp_value += 7
							else
								if rule_table[new_state-1] != 1 
									temp_value += 7
								end
							end
						end
					end
					if dfa1_record.index(temp_next_state) == nil
						temp_value += 5
					end
				end
			end
		end


		if dfa2_trace.length() != 0	
			dfa2_trace.each do |state|
				temp_next_state = trans_matrix_2[state[0]][index]	
				if match_matrix_2[temp_next_state][0] == 1 #dead_state
					temp_value -= 10
				else
					match_matrix_2[temp_next_state][1..match_matrix_2[temp_next_state].length-1].each do |new_state|
						if (state[1..state.length-1].index(tsi_matrix[new_state-1][0]) != nil)  && (tsi_matrix[new_state-1][2] == 0) # activate a new state 0.former record 2. not a final state
							if tsi_matrix[new_state-1][1] != 0
								temp_value += 7
							else
								if rule_table[new_state-1] != 1 
									temp_value += 7
								end
							end

						end
					end
					if dfa2_record.index(temp_next_state) == nil
						temp_value += 5
					end
				end
			end
		end
		value_table[index][1] = (temp_value*(rand()*0.2+0.8)).ceil
	end
end

def get_the_max()
	copy_value_table = []
	value_table.each do |ele|
		copy_value_table<<value_table.clone
	end
	copy_value_table.sort!{|a,b|
		a[1] <==> b[1]
	}.reverse!
	copy_value_table[0][0]
end

def get_the_next(char_c)
	new_state_dfa0 = []
	new_state_dfa1 = []
	new_state_dfa2 = []
	


		
end



while true
	output_file_variable= File.new("#{output_file}_#{count}","w+:ASCII-8BIT")
	dfa0_record = []
	dfa1_record = []
	dfa2_record = []

	dfa0_trace = [[0]]
	dfa1_trace = []
	dfa2_trace = []

	ascii_trace = []

	string_len.times do |index|

	end
	output_file_variable<<ascii_trace
	output_file.close()
	count += 1
end


