#!/bin/bash

files=$1
properties=$2
system_name=$3
mode=$4
echo "pwd = " $PWD
echo "files = $files"
echo "properties = $properties"
echo "system_name = $system_name"
echo "mode = $mode"

echo "size, query, run, time (date +%s.%N)">$system_name-results-times.csv
for size in 1 5
do
    echo "size = $size"
    for file in $files/*.rq
    do
        echo "file = $file"
        if [ $size -eq 1 ]
        then
            query_file=original/$(basename $file)
        else
            query_file=vig/$(basename $file)
        fi
        echo "query_file = $query_file"
        echo "calling pre_update_config_$system_name.sh $properties $size $query_file ..."
        sh pre_update_config_$system_name.sh $properties $size $query_file
        
        if [ $mode -eq 1 ]
        then
            echo "Warming up the system ..."
            sh run_$system_name.sh
        fi

        for i in {1..1}
        do

            #tiempo inicio
            start=$(date +%s.%N)

            echo "***** Evaluating: size $size - query_file $query_file - run $i ..."
            sh run_$system_name.sh
          
            #tiempo fin
            fin=$(date +%s.%N)

            # resta de tiempos
            dur=$(echo "$fin - $start" | bc)

            #guardamos el tiempo
            echo "$size, $query_file, $i, $dur">>$system_name-results-times.csv

            if [ $mode -eq 0 ]
            then 
                echo "Restaring the database ..."
                sh restart_database_$system_name.sh ${size}
            fi
        done
#cp $properties $properties.$system_name.$query_file

        #Elimina las ultimas 3 lineas del fichero
#       tail -n 3 $properties | wc -c | xargs -I {} truncate $properties -s -{}
        cp $properties gtfs$size.$(basename $file).$properties

        echo "calling post_update_config_$system_name.sh $properties..."
        sh post_update_config_$system_name.sh $properties
        echo ""
    done
    
done

echo "Bye"
