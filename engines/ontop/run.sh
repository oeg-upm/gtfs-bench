#!/bin/bash

#properties, mapping, querypath, size,query,time
size=$4
query=$5
run=$6
type=$7
#echo "size, query, run, time (date +%s.%N)">../results/results-times.csv
#start time
start=$(date +%s.%N)
./ontop query -m $2 -p $1 -q $3
#finish time
finish=$(date +%s.%N)
#duration
dur=$(echo "$finish - $start" | bc)

echo "$size, $query, $run, $type, $dur">>../results/results-times.csv

