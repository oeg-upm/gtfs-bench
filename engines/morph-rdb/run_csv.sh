#!/bin/bash
#properties, mapping, querypath, size,query,time
size=$1
query=$2
run=$3
typ=$4
flag=0
#start time
start=$(date +%s.%N)
java -cp .:morph-rdb.jar:dependency/* es.upm.fi.dia.oeg.morph.r2rml.rdb.engine.MorphCSVRunner properties gtfs.morph-rdb-csv.properties
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
