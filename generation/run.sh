#!/bin/bash

run csv2sql
(if the sql doesnt exist we create the file)
java -jar morph-csv-1.0.jar -c config.json

mysql -u root -p oeg gtfs < gtfs.sql

run vig
(get the scale from environments)

 java -jar vig-distribution-1.8.0-jar-with-dependencies.jar --res=resources --scale=$scale

run distribution
./distribution/run.sh