#! /bin/bash

#path_file=""
#current_directory=$(pwd)
total=0
subtotal=0
count=0
subcount=0

for z in $(ls)
do
	if [ -d $z ];then
		total=$(($total+1))
	fi
done

for x in $(ls)
do
	if [ -d $x ];then
		count=$(($count+1))
		subtotal=0
		subcount=0
		cd $x
		if [ -d result ];then
			echo directory_exist
		else
			mkdir -p result
		fi
		for t in $(ls)
		do
			subtotal=$(($subtotal+1))
		done
		for i in $(ls) 
		do
			subcount=$(($subcount+1))
			if [ "$i" != "run_dfa.sh" ];then
				if [ "$i" != "result" ];then
					echo $(pwd)
					valgrind --log-file="$(pwd)/result/$i" --tool=cachegrind ../../../../ruby_SSA/c_bin/dfa_nas ../../../../ruby_SSA/resource/bro217_trans_matrix $i 
				fi
			fi	
			echo "$subcount/$subtotal"
		done
		echo "$count/$total"
		cd ..
	fi
done

