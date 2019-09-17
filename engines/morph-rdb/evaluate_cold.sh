#!/bin/bash

#sh ../evaluate.sh ../../queries properties/gtfs.morph-rdb.properties morph-rdb 0 ../../results
#!/bin/bash
# i = size of dataset
# j = num of query

for i in 1 5 10 50 100 500
do
	for j in {1..18}
	do
		for t in 1 2 3 4 5
		do
			#properties, mapping, querypath, size,query,time
			if [[ $i -eq 1 ]];then
            # original queries
			# ./run.sh $size, $query, $run, $type
             ./run.sh $i $j $t 'cold'
             
			else
            #VIG queries
				
			fi
			rm /data/gtfs-rdb-$i/flag.txt
			sleep 5m
		done
	done
done