#!/bin/bash
#properties, mapping, querypath, size,query,time
size=$1
query=$2
run=$3
typ=$4
flag=0
if [ $size -eq 1 ]
    then
        path=/queries/original/$query
    else
        path=/queries/vig/$query
fi
#start time
start=$(date +%s.%N)
/Ontario/scripts/runExperiment.py -c /configurations/myconfig.json -q $path -r True > ../results/result-gtfs${size}-$query.log || flag=1
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

