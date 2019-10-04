#!/bin/bash
cd morphcsv
start=$(date +%s.%N)
java -cp .:morph-csv.jar:lib/* es.upm.fi.dia.oeg.Morphcsv -c $1
finish=$(date +%s.%N)
#duration
dur=$(echo "$finish - $start" | bc)
echo "$2, $3, $4, $dur" >> ../results/results-time.csv
cd ..
