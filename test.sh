#! /bin/bash

for i in $(ls) 
do
		if [ -d "$i" ];then
			cd $i
			ls
			cd ..
		fi
done
