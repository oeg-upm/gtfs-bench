#!/bin/bash

#properties, mapping, querypath, size,query,time
size=$1
query=$2
run=$3
typ=$4
flag=0

#start time
start=$(date +%s.%N)
java -jar morph-xr2rml-4.0.0.jar  --configDir properties  --configFile gtfs.morph-xr2rml.properties || flag=1
#finish time
finish=$(date +%s.%N)
#duration
dur=$(echo "$finish - $start" | bc)

if [ $flag -eq 1 ]
then
        dur=Error
fi

#echo "$size, $query, $run, $type, $dur">>../results/results-times.csv
echo "$size, $query, $run, $typ, $dur">>../results/results-times.csv
