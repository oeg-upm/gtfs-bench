#!/bin/bash
size=$1
query=$2
run=$3
echo "size, query, run, time (date +%s.%N)">../results/results-times.csv
#start time
start=$(date +%s.%N)
#java -jar morph-xr2rml-4.0.0.jar  --configDir .  --configFile gtfs.morph-xr2rml.properties
#finish time
finish=$(date +%s.%N)
#duration
dur=$(echo "$finish - $start" | bc)

echo "$size, $query, $run, $dur">>../results/results-times.csv
