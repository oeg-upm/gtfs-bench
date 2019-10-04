#!/bin/bash
#declare -a array=("json" "csv" "xml" "best" "worst" "random")
declare -a array=("json")
echo "size, query, run, type,time (date +%s.%N)" > ../results/results-times.csv

for p in "${array[@]}"
do
        for i in 500
        do
			cp -r /data/gtfs-$p-$i/* /data/
			# create config
			/Ontario/scripts/create_rdfmts.py -s /configurations/datasources-$p.json -o /configurations/myconfig-$p.json
			for j in 3
			do
				for t in 1
				do
					echo "++++++++++++++++++++++++++++++++++++++++++++++"
					echo  "size-$i-q${j}.rq-run-$t-$p"
					echo "size $i query $j run $t $p"
					timeout -s SIGKILL 60m  ./run.sh $i q${j}.rq $t $p
					#Status of timeout
					exit_status=$?
					if [ $exit_status -eq 137 ]
					then
						echo "$i, q${j}.rq, $t, $p, TimeOut">> ../results/results-times.csv
						echo "+++++++++++TimeOut: no more run iterations for query q${j}.rq +++++++++++++++"
						break
					fi

				done
			done
			rm /data/*.*
        done

done
