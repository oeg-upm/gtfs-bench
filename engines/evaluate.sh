#!/bin/bash

queryfilesdir=$1
properties=$2
system_name=$3
mode=$4
resultdir=$5

echo "pwd = " $PWD
echo "files = $files"
echo "properties = $properties"
echo "system_name = $system_name"
echo "mode = $mode"

#echo "size, query, run, time (date +%s.%N)">$resultdir/$system_name-results-times.csv
for size in 1 5
do
    echo "size = $size"
    for file in $queryfilesdir/*.rq
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
            #sh run_$system_name.sh
            docker exec -it ${system_name} run_$system_name.sh $system_name $resultdir $size $query_file 0
        fi

        for i in {1..1}
        do
            echo "***** Evaluating: size $size - query_file $query_file - run $i ..."
            #sh run_$system_name.sh
            docker exec -it ${system_name} run_$system_name.sh $system_name $resultdir $size $query_file $i

            #guardamos el tiempo
            #echo "$size, $query_file, $i, $dur">>$resultdir/$system_name-results-times.csv

            if [ $mode -eq 0 ]
            then 
                echo "Restaring the database ..."
                sh restart_database_$system_name.sh ${size}
            fi
        done

        cp $properties gtfs$size.$(basename $file).$properties

        echo "calling post_update_config_$system_name.sh $properties..."
        sh post_update_config_$system_name.sh $properties
        echo ""
    done
    
done

echo "Bye"
