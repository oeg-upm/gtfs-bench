#!/bin/bash

properties=$1
size=$2
query=$3

port=27017

echo "updating config file"
if [ $size -eq 1 ]
then
port=27017
elif [ $size -eq 5 ]
then
port=27018
elif [ $size -eq 10 ]
then
port=27019
elif [ $size -eq 50 ]
then
port=27020
elif [ $size -eq 100 ]
then
port=27021
elif [ $size -eq 500 ]
then
port=27022
else
port=27017
fi

echo "updating config file $properties"

#la configuracion depende del tamano y query
echo "query.file.path=$query">>$properties
echo "output.file.path=results/result-gtfs$size-$query.xml">>$properties
echo "database.name[0]=gtfs">>$properties
echo "database.url[0]=mongodb://127.0.0.1:$port">>$properties
