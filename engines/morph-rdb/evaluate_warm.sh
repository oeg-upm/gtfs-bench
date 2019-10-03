#!/bin/bash


for i in 1 5 10 50 100 500
do
	for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
	do
		for t in 1 2 3 4 5 6
		do
			#properties, mapping, querypath, size,query,time
			# Load properties configuration
			./pre_update_config.sh gtfs.morph-rdb.properties $i q${j}.rq 'warm'
			# Run engine
			timeout -s SIGKILL 60m ./run.sh $i q${j}.rq $t 'warm' ||echo "$i, q${j}.rq, $t, warm, TimeOut">> ../results/results-times.csv
			# Delete properties configuration
			./post_update_config.sh gtfs.morph-rdb.properties

		done
	done
done
