#!/bin/bash

properties=$1
size=$2
query=$3

echo "updating config file"

#la configuracion depende del tamano y query
echo "query.file.path=$query">>$properties
echo "output.file.path=results/result-gtfs$size-$query.xml">>$properties
echo "database.name[0]=gtfs$size">>$properties
echo "database.url[0]=jdbc:mysql://mysql-morph:3306/morph_example?allowPublicKeyRetrieval=true&useSSL=false">>$properties
