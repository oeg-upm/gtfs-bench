#!/bin/bash

properties=$1
size=$2
query=$3

port=3306

echo "updating config file"
if [ $size -eq 1 ]
then
  port=3306
elif [ $size -eq 5 ]
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

#la configuracion depende del tamano y query
echo "query.file.path=$query">>$properties
echo "output.file.path=results/result-gtfs$size-$(basename $query).xml">>$properties
echo "database.name[0]=gtfs$size">>$properties
echo "database.url[0]=jdbc:mysql://mysql-gtfs$size:$port/morph_example?allowPublicKeyRetrieval=true&useSSL=false">>$properties
