#!/bin/bash

#sh ../evaluate.sh ../../queries properties/gtfs.morph-rdb.properties morph-rdb 0 ../../results
# i = size of dataset
# j = num of query

echo "size, query, run, type,time (date +%s.%N)" > ../results/results-times.csv

for i in 1 5 10 50 100 500
do
	for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
	do
		for t in 1 2 3 4 5
		do
			#properties, mapping, querypath, size,query,time
			echo "size $i  query $j  run $t"
			#echo  $i q${j}.rq $t 'cold'
			# Load properties configuration
			./pre_update_config.sh gtfs.morph-rdb.properties $i q${j}.rq 'cold'
			# Run engine ----> add timeout 60min
			timeout -s SIGKILL 60m  ./run.sh $i q${j}.rq $t 'cold' ||echo "$i, q${j}.rq, $t, cold, TimeOut">> ../results/results-times.csv
			# Delete properties configuration
			./post_update_config.sh gtfs.morph-rdb.properties

			# restart database
			echo "delete :  /data/gtfs-rdb-$i/flag.txt"
			echo "Restart data base..."
			rm /data/gtfs-rdb-$i/flag.txt
			sleep 2m

		done
	done
done
