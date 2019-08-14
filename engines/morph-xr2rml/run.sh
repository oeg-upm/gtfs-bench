#!/bin/bash

FILES=queries/original/*.rq
properties=properties/gtfs.properties
system_name=morph-xr2rml

echo "size, query, run, time (date +%s.%N)">results/times.csv
for size in 1 5
do
    for file in $FILES
    do
        echo "**********************************************"
        if [ $size -eq 1 ]
        then
            query=original/$(basename $file)
        else
            query=vig/$(basename $file)
        fi
        #sleep 2
        #la configuracion depende del tamano y query
        echo "query.file.path=$query">>$properties
        echo "output.file.path=results/result-gtfs$size-$query.xml">>$properties
        echo "database.name[0]=gtfs$size">>$properties

        for i in 1 2 3 4 5
        do

            #tiempo inicio
            start=$(date +%s.%N)

            echo "Evaluating: size $size - query $query - run $i"
            #java -jar morph-xr2rml-4.0.0.jar  --configDir  data/original/
            sh run_$system_name.sh
          
            #tiempo fin
            fin=$(date +%s.%N)

            # resta de tiempos
            dur=$(echo "$fin - $start" | bc)

            #guardamos el tiempo
            echo "$size, $query, $i, $dur">>results/times.csv

        done
        #Elimina las ultimas 3 lineas del fichero
        tail -n 3 $properties | wc -c | xargs -I {} truncate $properties -s -{}
    done
done

