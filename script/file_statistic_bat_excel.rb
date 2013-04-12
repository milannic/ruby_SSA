# -*- coding:utf-8 -*-
require 'writeexcel'

workbook = WriteExcel.new('result.xls')
worksheet1 = workbook.add_worksheet #original data
worksheet2 = workbook.add_worksheet	#sampling_5_times data
worksheet3 = workbook.add_worksheet #sampling_25_times data
worksheet4 = workbook.add_worksheet #sampling_100_times data
worksheet5 = workbook.add_worksheet #sampling_all_times data

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


dirp = Dir.open(".")
expand_path =  File.expand_path(".")

output_file = expand_path[expand_path.rindex("/")+1..expand_path.length-1]

timestamp = Time.new.strftime("%Y-%m-%d-%H-%M")




dirp.each do |file|
	if File.directory?(file)
		if File.exist?("#{expand_path}/#{file}/result")
			statistic_file = File.new("#{output_file}_#{timestamp}",'w+')
			statistic_file<<"#{file}\n"
			worksheet.write(count,1,"#{file}")
			count += 1
			dirp_2 = Dir.open("#{expand_path}/#{file}/result")	
			dirp_2.each do |inner_file|
				unless inner_file =~ /^\.+/
					innner_file_open = File.open("#{expand_path}/#{file}/result/#{inner_file}",'r+')
					innner_file_open.each do |line|	
						if line.chop! =~ /D1\s+misses:/
							count += 1
							line.delete!("\s")
							d1_misses = line[line.index(':')+1..line.index('(')-1].delete!(',').to_i
							statistic_file<<d1_misses<<":"
							worksheet1.write(count,0,d1_misses.to_s)
						end

						if line.chop! =~ /LLd\s+misses:/
							line.delete!("\s")
							lld_misses = line[line.index(':')+1..line.index('(')-1].delete!(',').to_i
							statistic_file<<lld_misses<<endl
							worksheet1.write(count,1,lld_misses.to_s)
							break
						end
					end
					innner_file_open.close
				end
			statistic_file.close

			#input file
			count_input = 0
			excel_input = File.new("#{output_file}_#{timestamp}",'r+')
			file_name = excel_input.gets.chop!
			count_5 += 1	
			count_25 += 1	
			count_100 += 1	
			count_all += 1	
			worksheet2.write(count_5,0,"#{file_name}")
			worksheet3.write(count_25,0,"#{file_name}")
			worksheet4.write(count_100,0,"#{file_name}")
			worksheet5.write(count_all,0,"#{file_name}")
			count_5 += 1	
			count_25 += 1	
			count_100 += 1	
			count_all += 1	
			excel_input.each do |line|
				temp_value = line.chop!.split(":")[1].to_i-base_value
				if count_input == 0
					p temp_value
				end
				per_array_5 << temp_value
				per_array_25 << temp_value
				per_array_100 << temp_value
				count_input += 1
				if count_input%5 == 0
					all_array_5_mean<<mean(per_array_5)
					worksheet2.write(count_5,0,mean(per_array_5).to_s)
					worksheet2.write(count_5,1,variance(per_array_5).to_s)
					count_5 += 1
					per_array_5 = []
				end

				if count_input%25 == 0
					all_array_25_mean<<mean(per_array_25)
					worksheet3.write(count_25,0,mean(per_array_25).to_s)
					worksheet3.write(count_25,1,variance(per_array_25).to_s)
					count_25 += 1
					per_array_25 = []
				end
					
				if count_input%100 == 0
					all_array_100_mean<<mean(per_array_100)
					worksheet4.write(count_100,0,mean(per_array_100).to_s)
					worksheet4.write(count_100,1,variance(per_array_100).to_s)
					count_100 += 1
					per_array_100 = []
				end
			end
			
			worksheet5.write(count_all,0,"5")
			worksheet5.write(count_all,1,mean(all_array_5_mean).to_s)
			worksheet5.write(count_all,2,variance(all_array_5_mean).to_s)
			count_all += 1

			worksheet5.write(count_all,0,"25")
			worksheet5.write(count_all,1,mean(all_array_25_mean).to_s)
			worksheet5.write(count_all,2,variance(all_array_25_mean).to_s)
			count_all += 1

			worksheet5.write(count_all,0,"100")
			worksheet5.write(count_all,1,mean(all_array_100_mean).to_s)
			worksheet5.write(count_all,2,variance(all_array_100_mean).to_s)
			count_all += 1

			excel_input.close()
			end
		end
	end	
end
workbook.close
