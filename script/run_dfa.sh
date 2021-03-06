#! /bin/bash

path_file=""
current_directory=$(pwd)
count=0

if [ -d result ];then
	echo directory_exist
else
	mkdir -p result
fi

for i in $(ls) 
	do
		#echo $i
		if [ "$i" != "run_dfa.sh" ];then
			if [ "$i" != "result" ];then
				path_file="$current_directory/$i"
				valgrind --log-file="$current_directory/result/$i" --tool=cachegrind ../../../ruby_SSA/c_bin/dfa_nas ../../../ruby_SSA/resource/bro217_trans_matrix $i 
			fi
		fi	
done

