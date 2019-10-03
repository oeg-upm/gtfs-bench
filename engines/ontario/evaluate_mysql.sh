#!/bin/bash


echo "size, query, run, type,time (date +%s.%N)" > ../results/results-times.csv


for i in 1 5 10 50 100 500
do
    # create config
    /Ontario/scripts/create_rdfmts.py -s /configurations/datasources-mysql.json -o /configurations/myconfig.json
    for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
    do
        for t in 1 2 3 4 5
        do
            echo "++++++++++++++++++++++++++++++++++++++++++++++"
            echo  "size-$i-q${j}.rq-run-$t-$p"
            echo "size $i query $j run $t $p"
            timeout -s SIGKILL 60m  ./run.sh $i q${j}.rq $t $p ||echo "$i, q${j}.rq, $t, $p, TimeOut">> ../results/results-times.csv                                       
        done
    done
   
    #Aqui cambiar los puertos con sed -i --> para remplazar el puerto
    #TODO
    if [ $size -eq 5 ]
    then
    port=3307
    elif [ $size -eq 10 ]
    then
    port=3308
    elif [ $size -eq 50 ]
    then
    port=3309
    elif [ $size -eq 100 ]
    then
    port=3310
    elif [ $size -eq 500 ]
    then
        port=3311
    else
        port=3306
    fi
    aux=(( $port - 1 ))
    sed -i 's/$aux/$port/g' /configurations/datasources-mysql.json
done

