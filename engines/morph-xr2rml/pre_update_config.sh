#!/bin/bash

properties=properties/$1
size=$2
query_id=$3

port=27017
query_file="vig/${query_id}"
echo "updating config file"
if [ $size -eq 1 ]
then
port=27017
query_file="original/${query_id}"
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
echo "query.file.path=../../queries/$query_file">>$properties
echo "output.file.path=../../results/result-gtfs$size-${query_id}.xml">>$properties
echo "database.name[0]=gtfs">>$properties
echo "database.url[0]=mongodb://172.17.0.1:$port">>$properties
