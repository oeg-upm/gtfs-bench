#!/bin/bash

FILES=../../queries/original/*.rq

echo "size, query, run, time (date +%s.%N)">results/times.csv

for size in 1 5
    do
    for file in $FILES
        do
        #la configuracion depende de el tama–o y query
        echo "query.file.path=$query">>morph.properties
        echo "output.file.path=../../results/result-gtfs1-$query.xml">>morph.properties
        echo "database.name[0]=gtfs$size">>morph.properties

        for i in 1 2 3 4 5
        do
#query=$(echo  $file | cut -d "/" -f3)
        query=$(basename $file)
        echo "**********************************************"
        echo $query
        echo "**********************************************"
        #sleep 5  # Waits 5 seconds.


        #tiempo inicio
        start=$(date +%s)
        echo "Evaluating size $size - query $query - run $i"
        #java -jar morph-xr2rml-4.0.0.jar  --configDir  data/original/
        fin=$(date +%s)
        #tiempo fin
        # resta de tiempos
        dur=$(echo "$fin - $start" | bc)
        #guardamos el tiempo
        echo "$size, $query, $i, $dur">>results/times-1.csv

        #Elimina la ultima linea del fichero
        #sed -i '74,76d' morph.properties
        done
        #head -n -3 morph.properties > temp.txt ; mv temp.txt morph.properties
        tail -n 3 "morph.properties" | wc -c | xargs -I {} truncate "morph.properties" -s -{}
    done
done

