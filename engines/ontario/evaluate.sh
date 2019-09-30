#!/bin/bash
declare -a array=("json" "csv" "xml" "best" "worst" "random")

echo "size, query, run, type,time (date +%s.%N)" > ../results/results-times.csv

for p in "${array[@]}"
do
	for i in 1 5 10 50 100 500
	do
		cp -r /data/gtfs-$p-$i/* /data/
		/Ontario/scripts/create_rdfmts.py -s /configurations/datasources-$p.json -o /configurations/myconfig.json
		for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
		do
			for t in 1 2 3 4 5
			do
				echo "size $i query $j run $t $p"
				timeout -s SIGKILL 60m  ./run.sh $i q${j}.rq $t $p ||echo "$i, q${j}.rq, $t, $p, TimeOut">> ../results/results-times.csv                                       
			done
		done
		rm /data/*.*
		if [ $p -eq "worst" ]
		then
			sed -i 's/worst/random/g' /configurations/datasources-dist.json
		fi
		if [ $p -eq "best" ]
		then
			sed -i 's/best/worst/g' /configurations/datasources-dist.json
		fi
	done

done

rm /data/*.*