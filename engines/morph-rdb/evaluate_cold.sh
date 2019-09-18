#!/bin/bash

#sh ../evaluate.sh ../../queries properties/gtfs.morph-rdb.properties morph-rdb 0 ../../results
#!/bin/bash
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
					if [ $i -eq 1 ]
					then
							# original queries
							#./run.sh $size, $query, $run, $type
							#echo  $i q${j}.rq $t 'cold'
							# Load properties configuration
							./pre_update_config.sh gtfs.morph-rdb.properties $i q${j}.rq
							# Run engine
							./run.sh $i q${j}.rq $t 'cold'
							# Delete properties configuration
							./post_update_config.sh gtfs.morph-rdb.properties
					else
							#VIG queries
							echo  $i q${j}.rq $t 'cold'
					fi
					# restart database
					#echo "delete :  /data/gtfs-rdb-$i/flag.txt"
                done
        done
done
