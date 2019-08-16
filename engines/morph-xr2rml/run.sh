#!/bin/bash

FILES=queries/original/*.rq
properties=properties/gtfs.properties
system_name=morph-xr2rml
mode=warm

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
        #echo "query.file.path=$query">>$properties
        #echo "output.file.path=results/result-gtfs$size-$query.xml">>$properties
        #echo "database.name[0]=gtfs$size">>$properties
        sh update_config_$system_name.sh $properties $size $query
        
        if [ $mode -eq warm ]
        do
            echo "Warming up the system ..."
            sh run_$system_name.sh
        done

        for i in 1 2 3 4 5
        do

            #tiempo inicio
            start=$(date +%s.%N)

            echo "Evaluating: size $size - query $query - run $i ..."
            sh run_$system_name.sh
          
            #tiempo fin
            fin=$(date +%s.%N)

            # resta de tiempos
            dur=$(echo "$fin - $start" | bc)

            #guardamos el tiempo
            echo "$size, $query, $i, $dur">>results/times.csv

            if [ $mode -eq cold ]
            do
                echo "Restaring the database ..."
                sh restart_database_$system_name.sh
            done

        done
        #Elimina las ultimas 3 lineas del fichero
        tail -n 3 $properties | wc -c | xargs -I {} truncate $properties -s -{}
    done
done

