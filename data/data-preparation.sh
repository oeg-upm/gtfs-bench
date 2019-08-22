#!/bin/bash
declare -a arr=("csv" "json" "rdb" "xml" "dist")
count=0

# download from data-url
while IFS=, read -r format gtfs gtfs5 gtfs10 gtfs50 gtfs100 gtfs500 #gtfs1000 gtfs5000
do
	if [[ $gtfs =~ ^http.* ]]; then
	    wget -O gtfs-${arr[$count]}-1.zip $gtfs 
	    wget -O gtfs-${arr[$count]}-5.zip $gtfs5 
	    wget -O gtfs-${arr[$count]}-10.zip $gtfs10 
	    wget -O gtfs-${arr[$count]}-50.zip $gtfs50 
	    wget -O gtfs-${arr[$count]}-100.zip $gtfs100 
	    wget -O gtfs-${arr[$count]}-500.zip $gtfs500 
	    #wget -O gtfs-${arr[$count]}-1000.zip $gtfs1000 
	    #wget -O gtfs-${arr[$count]}-5000.zip $gtfs5000

	    # because the file contains more rows (rdf and graphs)
	    if [ $count ==  4 ]; then
	    	break
	    fi

	    ((count++))
	fi
done < data-url.csv

#unzip de files
for j in "${arr[@]}"
do
	for i in 1 5 10 50 100 500 #1000 5000
	do
		unzip gtfs-$j-$i.zip -d gtfs-$j-$i
	done
done

rm *.zip

#create the docker images from mysql (naive and ontop)
docker-compose -f docker-compose.yml up -d
#docker-compose -f docker-compose-ontop.yml up -d
sleep 60
#copy the schema and scripts to the corresponding sql and run the load scripts
for i in 1 5 10 50 100 500
do
	cp schema.sql gtfs-rdb-$i/
	cp schema-ontop.sql gtfs-rdb-$i/
	echo "**********************************"
	echo "loading $i size"
	echo "**********************************"
	docker exec -it -w /data/  gtfs${i}_mysql mysql -u root -poeg  -e 'source schema.sql'
	docker exec -it -w /data/   gtfs${i}_ontop_mysql mysql -u root -poeg  -e 'source schema-ontop.sql'
#	docker exec -it -w /data/  gtfs$i_mysql mysql -u root -poeg  -e 'source schema.sql'
#	docker exec -it -w /data/  gtfs$i_ontop_mysql mysql -u root -poeg  -e 'source schema-ontop.sql'

done

#preparation of mongodb
for i in 1 5 10 50 100 500
do
	cp mongodb-* gtfs-json-$i/
	echo "**********************************"
	echo "loading $i size"
	echo "**********************************"
	docker exec -it -w /data gtfs${i}_mongo ./mongodb-import-gtfs.sh
done