#!/bin/bash

FILES=queries/original/*.rq
echo "size, query, run, time (date +%s.%N)">results/times.csv
for size in 1 5
do
    properties=properties/gtfs.properties
    for file in $FILES
    do
        echo "**********************************************"

        #la configuracion depende del tamano y query
        echo "query.file.path=$query">>$properties
        echo "output.file.path=results/result-gtfs$size-$query.xml">>$properties
        echo "database.name[0]=gtfs$size">>$properties

        for i in 1 2 3 4 5
        do
            if [ $size -eq 1 ]
            then
                query=original/$(basename $file)
            else
                query=vig/$(basename $file)
            fi

            #sleep 2

            #tiempo inicio
            start=$(date +%s.%N)
            echo "Evaluating: size $size - query $query - run $i"
            #java -jar morph-xr2rml-4.0.0.jar  --configDir  data/original/
            fin=$(date +%s.%N)
            #tiempo fin
            # resta de tiempos
            dur=$(echo "$fin - $start" | bc)
            #guardamos el tiempo
            echo "$size, $query, $i, $dur">>results/times.csv

        done
        #Elimina la ultima linea del fichero
        tail -n 3 $properties | wc -c | xargs -I {} truncate $properties -s -{}
    done
done

