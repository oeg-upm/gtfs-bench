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
                    # Load properties configuration
                    ./pre_update_config.sh gtfs.morph-xr2rml.properties $i q${j}.rq 'cold'
                    # Run engine
                    timeout -s SIGKILL 60m   ./run.sh $i q${j}.rq $t 'cold'  ||echo "$i, q${j}.rq, $t, cold, TimeOut">> ../results/results-times.csv
                    # Delete properties configuration
                    ./post_update_config.sh gtfs.morph-xr2rml.properties
                    # restart database
                    echo "delete :  /data/gtfs-json-$i/flag_mongo.txt"
                    echo "Restart data base..."
                    rm /data/gtfs-json-$i/flag_mongo.txt
                    sleep 2m

                done
        done
done
