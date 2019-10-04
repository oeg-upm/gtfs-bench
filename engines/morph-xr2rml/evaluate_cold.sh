#!/bin/bash

echo "size, query, run, type,time (date +%s.%N)" > ../results/results-times.csv

for i in 1 5 10 50 100 500
do
        for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
        do
                for t in 1 2 3 4 5
                do
                    echo "size:$i  query: q${j}.rq run:$t "
                    # Load properties configuration
                    ./pre_update_config.sh gtfs.morph-xr2rml.properties $i q${j}.rq 'cold'
                    # Run engine
                    timeout -s SIGKILL 60m   ./run.sh $i q${j}.rq $t 'cold'
                    exit_status=$?
                    echo $exit_status
                    if [ $exit_status -eq 137 ]
                    then
                        # Delete properties configuration
                        ./post_update_config.sh gtfs.morph-xr2rml.properties
                        echo "$i, q${j}.rq, $t, cold, TimeOut">> ../reslts/results-times.csv
                        echo "+++++++++++TimeOut: no more iterations+++++++++++++++"
                        break
                    else
                        # Delete properties configuration
                        ./post_update_config.sh gtfs.morph-xr2rml.properties
                    fi
                    # Restart database
                    echo "delete :  /data/gtfs-json-$i/flag_mongo.txt"
                    echo "Restart data base..."
                    rm /data/gtfs-json-$i/flag_mongo.txt
                    sleep 2m

                done
        done
done
