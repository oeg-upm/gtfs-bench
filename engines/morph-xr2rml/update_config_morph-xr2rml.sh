#!/bin/bash

properties=$1
size=$2
query=$3

echo "updating config file"

#la configuracion depende del tamano y query
echo "query.file.path=$query">>$properties
echo "output.file.path=results/result-gtfs$size-$query.xml">>$properties
echo "database.name[0]=gtfs$size">>$properties
