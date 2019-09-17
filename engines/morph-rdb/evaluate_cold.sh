#!/bin/bash

#sh ../evaluate.sh ../../queries properties/gtfs.morph-rdb.properties morph-rdb 0 ../../results
#!/bin/bash
# i = size of dataset
# j = num of query

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
					# ./run.sh $size, $query, $run, $type
					#./run.sh
					echo  $i q${j}.rq $t 'cold'
				else
					#VIG queries
					echo  $i q${j}.rq $t 'cold'
				fi
				#echo "delete :  /data/gtfs-rdb-$i/flag.txt"
		done
	done
done
