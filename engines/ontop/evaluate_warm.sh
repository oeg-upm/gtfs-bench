#!/bin/bash

for i in 1 5 10 50 100 500
do
	for j in {1..17}
	do
		for t in 1 2 3 4 5
		do
			#properties, mapping, querypath, size,query,time
			if [[ $i -eq 1 ]];then
				/ontop/run.sh /ontop/properties/gtfs-$i.properties /mapping/gtfs-rdb.obda /queries/original/q$j.rq $i q$j $t
			else
				/ontop/run.sh /ontop/properties/gtfs-$i.properties /mapping/gtfs-rdb.obda /queries/vig/q$j.rq $i q$j $t
			fi
		done
	done
done
