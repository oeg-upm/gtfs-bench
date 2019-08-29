#!/bin/bash
system_name=$1
resultdir=$2
size=$3
query_file=$4
i=$5

if [ $i != 0 ]
then
    echo "size, query, run, time (date +%s.%N)">$system_name-results-times.csv
    #tiempo inicio
    start=$(gdate +%s.%N)
fi

echo "Running morph-rdb ..."
#java -cp .:morph-rdb.jar:lib/*:dependency/* es.upm.fi.dia.oeg.morph.r2rml.rdb.engine.MorphRDBRunner examples-mysql example1-query01-mysql.morph.properties

if [ $i != 0 ]
then
    #tiempo fin
    fin=$(gdate +%s.%N)
    # resta de tiempos
    dur=$(echo "$fin - $start" | bc)
    echo "$size, $query_file, $i, $dur">>$system_name-results-times.csv
fi




