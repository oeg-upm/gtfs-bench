#!/bin/bash

echo "size, query, run, time (date +%s.%N)">../results/results-times.csv
#start time
for size in 1 5 
do
    for query in {1..17}
    do
        #add propertie file config
        
        for run in 1 2 3 4 5 6
        do
            start=$(date +%s.%N)
            java -jar morph-xr2rml-4.0.0.jar  --configDir .  --configFile gtfs.morph-xr2rml.properties
            #finish time
            finish=$(date +%s.%N)
            #duration
            dur=$(echo "$finish - $start" | bc)
            echo "$size, $query, $run, $dur">>../results/results-times.csv
        done 
    done
done