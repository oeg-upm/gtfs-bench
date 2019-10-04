#!/bin/bash


echo "size, query, run, type,time (date +%s.%N)" > ../results/results-times.csv

#data size
for i in 1 5 10 50 100 500
do
    # create config
    /Ontario/scripts/create_rdfmts.py -s /configurations/datasources-mysql.json -o /configurations/myconfig-mysql.json
    #queries
    for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
    do
        for t in 1 2 3 4 5
        do
            echo "++++++++++++++++++++++++++++++++++++++++++++++"
            echo  "size-$i-q${j}.rq-run-$t-$p"
            echo "size $i query $j run $t $p"
            timeout -s SIGKILL 60m  ./run.sh $i q${j}.rq $t mysql                                

            exit_status=$?
            if [ $exit_status -eq 137 ]
            then
                echo "$i, q${j}.rq, $t, mysql, TimeOut">> ../results/results-times.csv
                echo "+++++++++++TimeOut: no more run iterations for query q${j}.rq +++++++++++++++"
                break
            fi

        done
    done

    # change configutation
    if [ $i -eq 5 ]
    then
            echo $i
            sed -i 's/gtfs1_mysql/gtfs5_mysql/g' /configurations/datasources-mysql.json
  
    elif [ $i -eq 10 ]
    then
            echo $i
            sed -i 's/gtfs5_mysql/gtfs10_mysql/g' /configurations/datasources-mysql.json
 
    elif [ $i -eq 50 ]
    then
            echo $i
            sed -i 's/gtfs10_mysql/gtfs50_mysql/g' /configurations/datasources-mysql.json
    
    elif [ $i -eq 100 ]
    then
            echo $i
            sed -i 's/gtfs50_mysql/gtfs100_mysql/g' /configurations/datasources-mysql.json
  
    elif [ $i -eq 500 ]
    then
            echo $i
            sed -i 's/gtfs100_mysql/gtfs500_mysql/g' /configurations/datasources-mysql.json
       
    else
        sed -i 's/gtfs500_mysql/gtfs1_mysql/g' /configurations/datasources-mysql.json
    fi
   
done

sed -i 's/gtfs500_mysql/gtfs1_mysql/g' /configurations/datasources-mysql.json
