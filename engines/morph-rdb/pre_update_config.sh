#!/bin/bash

properties=properties/$1
size=$2
query_id=$3
experim=$4

port=3306
query_file="vig/${query_id}"
echo "updating properties file"
if [ $size -eq 1 ]
then
  port=3306
  query_file="original/${query_id}"
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

#echo "+++++++++++PRE CONFIG+++++++++++++"
echo " properties $properties"
#echo " size $size"
echo " query_file ${query_file}"
#echo " port $port"
#cat $properties
#echo "+++++++++++++++++++++++++++"

echo "+++++++++++++++++++++properties $properties size $size query_id $query_id query_file $query_file port $port "


#la configuracion depende del tamano y query
echo "query.file.path=../../queries/$query_file">>$properties
echo "output.file.path=../../results/result-gtfs${size}-${experim}-${query_id}.xml">>$properties
echo "database.name[0]=gtfs">>$properties
echo "database.url[0]=jdbc:mysql://172.18.0.1:$port/gtfs?allowPublicKeyRetrieval=true&useSSL=false">>$properties
#echo "----------------"
#echo "END PRE CONF"
#echo "----------------"
