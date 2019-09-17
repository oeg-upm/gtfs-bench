#!/bin/bash
#properties, mapping, querypath, size,query,time
size=$1
query=$2
run=$3
type=$4
echo "size, query, run, time (date +%s.%N)">../results/results-times.csv
#start time
start=$(date +%s.%N)
java -cp .:morph-rdb.jar:lib/*:dependency/* es.upm.fi.dia.oeg.morph.r2rml.rdb.engine.MorphRDBRunner properties gtfs.morph-rdb.properties
#finish time
finish=$(date +%s.%N)
#duration
dur=$(echo "$finish - $start" | bc)

#echo "$size, $query, $run, $type, $dur">>../results/results-times.csv
echo "$size, $query, $run, $dur">>../results/results-times.csv

