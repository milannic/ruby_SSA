dirp = Dir.open(".")
endl = "\n"
expand_path =  File.expand_path(".")

output_file = expand_path[expand_path.rindex("/")+1..expand_path.length-1]

timestamp = Time.new.strftime("%Y-%m-%d-%H-%M")


statistic_file = File.new("#{output_file}_#{timestamp}",'w+')
p "#{output_file}_#{timestamp}"


dirp.each do |file|
	if File.directory?(file)
		if File.exist?("#{expand_path}/#{file}/result")
			p "#{expand_path}/#{file}/result"
			statistic_file<<"#{file}\n"<<"D1:LLD\n"
			d1_misses_count = 0
			lld_misses_count = 0
			total_number = 0
			dirp_2 = Dir.open("#{expand_path}/#{file}/result")	
			dirp_2.each do |inner_file|
				unless inner_file =~ /^\.+/
					p inner_file
					total_number += 1
					innner_file_open = File.open("#{expand_path}/#{file}/result/#{inner_file}",'r+')
					innner_file_open.each do |line|	
						if line.chop! =~ /D1\s+misses:/
							line.delete!("\s")
							d1_misses = line[line.index(':')+1..line.index('(')-1].delete!(',').to_i
							statistic_file<<d1_misses<<":"
							d1_misses_count += d1_misses	
						end

						if line.chop! =~ /LLd\s+misses:/
							line.delete!("\s")
							lld_misses = line[line.index(':')+1..line.index('(')-1].delete!(',').to_i
							statistic_file<<lld_misses<<endl
							lld_misses_count += lld_misses
							break
						end
					end
					innner_file_open.close
				end
			end
			statistic_file<<"average\n"
			statistic_file<<(d1_misses_count/total_number)<<":"<<(lld_misses_count/total_number)<<endl
		end
	end	
end
statistic_file.close
