input_file = File.new(ARGV[0],"r+:ASCII-8BIT")
file_name = input_file.gets.chop!
p file_name
p output_file_5 = File.new(file_name,"w+:ASCII-8BIT")
p output_file_25 = File.new("#{file_name}_25","w+:ASCII-8BIT")
p output_file_100 = File.new("#{file_name}_100","w+:ASCII-8BIT")
p output_file_all = File.new("#{file_name}_all","w+:ASCII-8BIT")
#p ARGV

base_value = 107169
endl = "\n"
title_string = ""
null_string = ""
per_array_5 = []
per_array_25 = []
per_array_100 = []
all_array_5_mean = []
all_array_25_mean = []
all_array_100_mean = []

count = 0

def sum(x)
	sum_value = 0.0
	x.each do |ele|
		sum_value += ele	
	end
	sum_value
end

def mean(x)
	sum(x)/x.length
end

def variance(x)
	mean_value = mean(x)
	variance_value = 0.0
	x.each do |ele|
		variance_value += (ele-mean_value)**2
	end
	variance_value = variance_value/x.length
end

def sigma(x)
	Math.sqrt(variance(x))
end

input_file.each do |line|
	temp_value = line.chop!.split(":")[1].to_i-base_value
	if count == 0
		p temp_value
	end
	per_array_5 << temp_value
	per_array_25 << temp_value
	per_array_100 << temp_value
	count += 1
	if count%5 == 0
		all_array_5_mean<<mean(per_array_5)
		output_file_5<<"mean : "<<mean(per_array_5)<<endl
		output_file_5<<"variance : "<<variance(per_array_5)<<endl
		per_array_5 = []
	end

	if count%25 == 0
		all_array_25_mean<<mean(per_array_25)
		output_file_25<<"mean : "<<mean(per_array_25)<<endl
		output_file_25<<"variance : "<<variance(per_array_25)<<endl
		per_array_25 = []
	end
		
	if count%100 == 0
		all_array_100_mean<<mean(per_array_100)
		output_file_100<<"mean : "<<mean(per_array_100)<<endl
		output_file_100<<"variance : "<<variance(per_array_100)<<endl
		per_array_100 = []
	end
end

output_file_all<<variance(all_array_5_mean)<<endl
output_file_all<<variance(all_array_25_mean)<<endl
output_file_all<<variance(all_array_100_mean)

input_file.close()
output_file_5.close()
output_file_25.close()
output_file_100.close()
output_file_all.close()
