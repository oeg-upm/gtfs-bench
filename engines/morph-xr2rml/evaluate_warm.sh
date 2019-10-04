#!/bin/bash


#size
for i in 1 5 10 50 100 500
do
	#queries
	for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
	do
		for t in 1 2 3 4 5
		do
			# Load properties configuration
			./pre_update_config.sh gtfs.morph-xr2rml.properties $i q${j}.rq 'warm'
			# Run engine
			timeout -s SIGKILL 60m  ./run.sh $i q${j}.rq $t 'warm'
			#Status of timeout
			exit_status=$?
			echo $exit_status
			if [ $exit_status -eq 137 ]
			then
					./post_update_config.sh gtfs.morph-xr2rml.properties
					echo "$i, q${j}.rq, $t, warm, TimeOut">> ../results/results-times.csv
					echo "+++++++++++TimeOut: no more iterations+++++++++++++++"
					break
			else
					./post_update_config.sh gtfs.morph-xr2rml.properties
			fi
			
		done
	done
done
