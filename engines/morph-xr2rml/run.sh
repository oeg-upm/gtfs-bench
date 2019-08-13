#!/bin/bash

FILES=../../queries/original/*.rq

echo "query, tiempo (date +%s.%N)">results/times-1.csv
for file in $FILES
do
for i in 1 2 3 4 5
do
query=$(echo  $file | cut -d "/" -f3)

echo "**********************************************"
echo $query
echo "**********************************************"
#sleep 5  # Waits 5 seconds.

#a–ade la query a la configuracion
echo "query.file.path=$query">>morph.properties
#echo "query.file.path=$query">>data/original/morph.properties
echo "output.file.path=../../results/result-gtfs1-$query.xml">>morph.properties
#tiempo inicio
start=$(date +%s)
java -jar morph-xr2rml.jar  --configDir  data/original/
fin=$(date +%s)
#tiempo fin
# resta de tiempos
dur=$(echo "$fin - $start" | bc)
#guardamos el tiempo
echo "$query, $i, $dur">>results/times-1.csv

#Elimina la ultima linea del fichero
sed -i '74,75d' morph.properties
done
done
