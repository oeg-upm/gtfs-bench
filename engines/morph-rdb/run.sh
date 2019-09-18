#!/bin/bash
#properties, mapping, querypath, size,query,time
size=$1
query=$2
run=$3
typ=$4

#start time
start=$(date +%s.%N)
java -cp .:morph-rdb.jar:lib/*:dependency/* es.upm.fi.dia.oeg.morph.r2rml.rdb.engine.MorphRDBRunner properties gtfs.morph-rdb.properties
#finish time
finish=$(date +%s.%N)
#duration
dur=$(echo "$finish - $start" | bc)

#echo "$size, $query, $run, $type, $dur">>../results/results-times.csv
echo "$size, $query, $run, $typ, $dur">>../results/results-times.csv
