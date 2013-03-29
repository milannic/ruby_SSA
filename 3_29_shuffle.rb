#! /usr/bin/ruby
# usage ruby filename argv[0] argv[1]


def random_delete(string_original)
	if string_original.length == 0
		return ""
	end
	position = (rand()*string_original.length).floor
	if position == 0
		string_original[1..string_original.length-1]
	elsif position == string_original.length 
		string_original[0..string_original.length-2]
	else
		string_original[0..position-1]+string_original[position+1..string_original.length-1]
	end
end

def random_swap(string_original)
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
	return string_original
end


def random_change(string_original)
	if string_original.length == 0
		return ""
	end
	#p string_original.length
	position = (rand()*string_original.length).floor
	range_factor = (rand()*8).floor
	#p range_factor
	#p string_original[position].ord
	#p string_original[position]
	string_original[position] = (string_original[position].ord^(1<<range_factor)).chr
	#p string_original[position].ord
	#p string_original[position]
	string_original
end

test_string = "abcdefg"
p test_string
test_string = random_change(test_string)
p test_string

10.times{
	test_string = random_change(test_string)
	p test_string
}

=begin
test_string = random_swap(test_string)
p test_string

10.times{
	test_string = random_swap(test_string)
	p test_string
}
=end

=begin
test_string = random_delete(test_string)
10.times{
	p test_string
	test_string = random_delete(test_string)
}
=end

=begin
if File.exist?(ARGV[0])
	string_file_original = File.open(ARGV[0],'r+')
	string_original = string_file_original.gets.chop
else
	exit
end

string_file_original.close()
=end
