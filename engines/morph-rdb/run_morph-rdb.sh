#!/bin/bash
system_name=$1
resultdir=$2
size=$3
query_file=$4
i=$5

resultfile=$resultdir/$system_name-results-times.csv

echo "i = ${i}"
if [ $i -eq 0 ]
then
    echo "Running morph-rdb ..."
    echo "query_file = ${query_file}"
    java -cp .:morph-rdb.jar:lib/*:dependency/* es.upm.fi.dia.oeg.morph.r2rml.rdb.engine.MorphRDBRunner . gtfs${size}.${query_file}.properties
else
    #tiempo inicio
    start=$(date +%s.%N)

    echo "Running morph-rdb ..."
    echo "query_file = ${query_file}"
    java -cp .:morph-rdb.jar:lib/*:dependency/* es.upm.fi.dia.oeg.morph.r2rml.rdb.engine.MorphRDBRunner . gtfs${size}.${query_file}.properties

    #tiempo fin
    fin=$(date +%s.%N)
    # resta de tiempos
    dur=$(echo "$fin - $start" | bc)
    echo "$size, $query_file, $i, $dur">>$resultfile
    cat $resultfile
fi

