#!/bin/bash


for i in 5 10 50 100 500 1000 5000
do
 java -jar vig-distribution-1.8.0-jar-with-dependencies.jar --res=resources --scale=$i
 cd src/main/resources/csvs
 ./clean.sh
 ./headers.sh
 zip $i.zip *.csv
 rm *.csv
 cd ../../../../
done 
