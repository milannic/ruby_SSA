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
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.01 -d
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.05 -d
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.1 -d
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.2 -d
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.3 -d
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.4 -d
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.5 -d
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.01 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.05 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.1 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.2 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.3 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.4 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.5 -c
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.01 -s
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.05 -s
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.1 -s
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.2 -s
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.3 -s
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.4 -s
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.5 -s
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.01 -m
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.05 -m
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.1 -m
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.2 -m
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.3 -m
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.4 -m
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i -r 0.5 -m
			fi
		fi	
done

