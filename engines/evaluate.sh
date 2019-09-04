#!/bin/bash

queryfilesdir=$1
properties=$2
system_name=$3
mode=$4
resultdir=$5

echo "pwd = " $PWD
echo "queryfilesdir = $queryfilesdir"
echo "properties = $properties"
echo "system_name = $system_name"
echo "mode = $mode"

resultfile=$resultdir/$system_name-results-times.csv

for size in 1 5
do
    echo "size = $size"
    if [ $size -eq 1 ]
    then
        query_files=$queryfilesdir/original/*.rq
    else
        query_files=$queryfilesdir/vig/*.rq
    fi

    for query_file in $query_files
    do
        echo "query_file = ${query_file}"
        query_id=$(basename ${query_file})
        echo "query_id = ${query_id}"

        new_properties=gtfs$size.${query_id}.properties
        cp $properties ${new_properties}
        echo "calling pre_update_config_$system_name.sh ${new_properties} $size $query_id ..."
        sh pre_update_config_$system_name.sh ${new_properties} $size $query_id

        if [ $mode -eq 1 ]
        then
            echo "Warming up the system ..."
            sh run_$system_name.sh $system_name $resultdir $size $query_id 0
            #docker exec -it  -w /${system_name} ${system_name}  sh run.sh $system_name $resultdir $size $query_file 0
        fi

        for i in 1 2
        do
            echo "***** Evaluating: size $size - query_file $query_file - run $i ..."
            sh run_$system_name.sh $system_name $resultdir $size $query_id $i
            #echo "executing docker exec -it ${system_name} -w /${system_name} ${system_name}  sh run.sh $system_name $resultdir $size $query_file $i"
            #docker exec -it  -w /${system_name} ${system_name}  sh run.sh $system_name $resultdir $size $query_file $i
            #docker exec  -it -w /morph-rdb  morph-rdb sh run_morph-rdb.sh
            #guardamos el tiempo
            #echo "$size, $query_file, $i, $dur">>$resultdir/$system_name-results-times.csv

            if [ $mode -eq 0 ]
            then
                echo "Restaring the database ..."
                #sh restart_database_$system_name.sh ${size}
            fi
        done

        #echo "calling post_update_config_$system_name.sh ${new_properties} ..."
        #sh post_update_config_$system_name.sh ${new_properties}
        #echo ""
    done

done

echo "Bye"
