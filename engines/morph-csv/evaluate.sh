#!/bin/bash

for i in 1 5 10 50 100 #500
do
        cp /data/gtfs-csv-$i/* /data/
        for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
        do
                string="s/q[0-9]*.rq/q$j.rq/g"
                sed -i $string /config.json
                for t in 1 2 3 4 5
                do
                        /run.sh /config.json $i q$j $t
                        rm /morphcsv/output/*.db
                        rm /morphcsv/output/*.sql
                        rm /morphcsv/output/*.ttl
                        rm /morphcsv/output/*.properties
                done
        done
	mkdir /results/gtfs-csv-$i
        mv /morphcsv/output/*.xml /results/
        if [ $i -eq 1 ]; then
                sed -i 's/original/vig/g' /config.json
                sed -i 's/annotations/annotations-vig/g' /config.json
        fi
        sed -i 's/q19.rq/q1.rq/g' /config.json
done

rm /data/*.csv
