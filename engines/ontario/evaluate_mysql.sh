#!/bin/bash


echo "size, query, run, type,time (date +%s.%N)" > ../results/results-times.csv


for i in 50 #100 500
do
    # create config
    /Ontario/scripts/create_rdfmts.py -s /configurations/datasources-mysql.json -o /configurations/myconfig-mysql.json
    for j in 1 #8 14 #17 # 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
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

    # change port
    if [ $i -eq 5 ]
    then
            echo $i
            sed -i 's/3306/3307/g' /configurations/datasources-mysql.json
    #port=3307
    elif [ $i -eq 10 ]
    then
            echo $i
            sed -i 's/3307/3308/g' /configurations/datasources-mysql.json
    #port=3308
    elif [ $i -eq 50 ]
    then
            echo $i
            sed -i 's/3308/3309/g' /configurations/datasources-mysql.json
    #port=3309
    elif [ $i -eq 100 ]
    then
            echo $i
            sed -i 's/3309/3310/g' /configurations/datasources-mysql.json
    #port=3310
    elif [ $i -eq 500 ]
    then
            echo $i
            sed -i 's/3310/3311/g' /configurations/datasources-mysql.json
        #port=3311
    else
        port=3306
    fi
    #aux='(( $port - 1 ))'
    #sed -i 's/$aux/$port/g' /configurations/datasources-mysql.json
done

sed -i 's/3311/3306/g' /configurations/datasources-mysql.json
