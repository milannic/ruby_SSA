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
				ruby ../../../ruby_SSA/shuffle_the_trace/disturb_trace.rb -i $i 
			fi
		fi	
done

