#!/bin/bash
declare -a arr=("csv" "json" "sql" "xml" "dist")
count=0

while IFS=, read -r format gtfs gtfs5 gtfs10 gtfs50 gtfs100 gtfs500 gtfs1000 gtfs5000
do
	if [[ $gtfs =~ ^http.* ]]; then
	    wget -O gtfs-${arr[$count]}-1.zip $gtfs 
	    wget -O gtfs-${arr[$count]}-5.zip $gtfs5 
	    wget -O gtfs-${arr[$count]}-10.zip $gtfs10 
	    wget -O gtfs-${arr[$count]}-50.zip $gtfs50 
	    wget -O gtfs-${arr[$count]}-100.zip $gtfs100 
	    wget -O gtfs-${arr[$count]}-500.zip $gtfs500 
	    wget -O gtfs-${arr[$count]}-1000.zip $gtfs1000 
	    wget -O gtfs-${arr[$count]}-5000.zip $gtfs5000

	    if [ $count ==  4 ]; then
	    	break
	    fi

	     ((count++))
	fi
done < data-url.csv

for j in "${arr[@]}"
do
	for i in 1 5 10 50 100 500 1000 5000
	do
		unzip $j/gtfs-$j-$i.zip -d gtfs-$j-$i
	done
done