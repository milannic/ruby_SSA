#! /bin/bash

path_file=""
current_directory=$(pwd)
count=0


for i in $(ls) 
	do
		#echo $i
		if [ "$i" != "disturb.sh" ];then
			if [ -d "$i" ];then
				continue
			else
				path_file="$current_directory/$i"
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -f 0.01 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -f 0.03 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -f 0.05 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -f 0.1 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -f 0.2 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -f 0.3 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -f 0.4 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -f 0.5 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -f 0.6 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -f 0.7 -c
			fi
		fi	
done

