#!/bin/bash

FILES=queries/original/*.rq
echo "size, query, run, time (date +%s.%N)">results/times.csv
for size in 1 5
    do
    properties=properties/gtfs-$size.properties
    for file in $FILES
        do
        #la configuracion depende del tamano y query
        echo "query.file.path=$query">>$properties
        echo "output.file.path=results/result-gtfs$size-$query.xml">>$properties
        echo "database.name[0]=gtfs$size">>$properties

        for i in 1 2 3 4 5
        do
        query=$(basename $file)
        echo "**********************************************"
        echo $query
        echo "**********************************************"
        #sleep 5  # Waits 5 seconds.


        #tiempo inicio
        start=$(date +%s.%N)
        echo "Evaluating size $size - query $query - run $i"
        #java -jar morph-xr2rml-4.0.0.jar  --configDir  data/original/
        fin=$(date +%s.%N)
        #tiempo fin
        # resta de tiempos
        dur=$(echo "$fin - $start" | bc)
        #guardamos el tiempo
        echo "$size, $query, $i, $dur">>results/times.csv

        #Elimina la ultima linea del fichero
        done
        tail -n 3 $properties | wc -c | xargs -I {} truncate $properties -s -{}
    done
done

