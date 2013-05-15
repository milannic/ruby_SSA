# -*- coding:utf-8 -*-
require 'writeexcel'

workbook = WriteExcel.new('result.xls')
worksheet0 = workbook.add_worksheet #original data
worksheet1 = workbook.add_worksheet #sampling_100_times data

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

count = 0
count_input = 0
count_5=0
count_25=0
count_100=0
count_all=0

base_value_d_ref = 5844877749
base_value_d1_miss = 1260107
base_value_lld_miss = 1259331

endl = "\n"
title_string = ""
null_string = ""
per_array_100_d_ref = []
per_array_100_d1_miss = []
per_array_100_lld_miss= []


dirp = Dir.open(".")
expand_path =  File.expand_path(".")

output_file = expand_path[expand_path.rindex("/")+1..expand_path.length-1]

timestamp = Time.new.strftime("%Y-%m-%d-%H-%M")




dirp.each do |file|
	if File.directory?(file)
		if File.exist?("#{expand_path}/#{file}/result")
			p file
			statistic_file = File.new("#{output_file}_#{timestamp}",'w+')
			statistic_file<<"#{file}\n"
			count += 1
			worksheet1.write(count,0,"#{file}")
			count += 1
			dirp_2 = Dir.open("#{expand_path}/#{file}/result")	
			dirp_2.each do |inner_file|
				unless inner_file =~ /^\.+/
					innner_file_open = File.open("#{expand_path}/#{file}/result/#{inner_file}",'r+')
					innner_file_open.each do |line|	
						if line.chop! =~ /D\s+refs:/
							count += 1
							line.delete!("\s")
							d_refers = line[line.index(':')+1..line.index('(')-1].delete!(',').to_i
							statistic_file<<d_refers<<":"
							worksheet0.write(count,0,d_refers)
						end

						if line.chop! =~ /D1\s+misses:/
							line.delete!("\s")
							d1_misses = line[line.index(':')+1..line.index('(')-1].delete!(',').to_i
							statistic_file<<d1_misses<<":"
							worksheet0.write(count,1,d1_misses)
						end

						if line.chop! =~ /LLd\s+misses:/
							line.delete!("\s")
							lld_misses = line[line.index(':')+1..line.index('(')-1].delete!(',').to_i
							statistic_file<<lld_misses<<endl
							worksheet0.write(count,2,lld_misses)
							break
						end
					end
					innner_file_open.close
				end
			end
			count += 1
			statistic_file.close

			#input file
			count_input = 0
			excel_input = File.new("#{output_file}_#{timestamp}",'r+')
			file_name = excel_input.gets.chop!
			count_100 += 1	
			worksheet1.write(count_100,0,"#{file_name}")
			count_100 += 1	
			excel_input.each do |line|
				temp_value_d_ref = line.chop!.split(":")[0].to_i-base_value_d_ref
				temp_value_d1_miss = line.chop!.split(":")[1].to_i-base_value_d1_miss
				temp_value_lld_miss= line.chop!.split(":")[2].to_i-base_value_lld_miss

				if count_input == 0
					p temp_value
				end

				per_array_100_d_ref << temp_value_d_ref
				per_array_100_d1_miss << temp_value_d1_miss
				per_array_100_lld_miss<< temp_value_lld_miss

				count_input += 1

				if count_input%100 == 0
					worksheet1.write(count_100,0,mean(per_array_100_d_ref))
					worksheet1.write(count_100,1,variance(per_array_100_d_ref))
					worksheet1.write(count_100,2,mean(per_array_100_d1_miss))
					worksheet1.write(count_100,3,variance(per_array_100_d1_miss))
					worksheet1.write(count_100,4,mean(per_array_100_lld_miss))
					worksheet1.write(count_100,5,variance(per_array_100_lld_miss))
					count_100 += 1
					per_array_100_d_ref = []
					per_array_100_d1_miss = []
					per_array_100_lld_miss = []
				end
			end
			excel_input.close()
		end
	end	
end
workbook.close
