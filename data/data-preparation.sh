#!/bin/bash
declare -a arr=("csv" "json" "rdb" "xml" "dist")
count=0

# download from data-url
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

#unzip de files
for j in "${arr[@]}"
do
	for i in 1 5 10 50 100 500 1000 5000
	do
		unzip $j/gtfs-$j-$i.zip -d gtfs-$j-$i
	done
done

rm *.zip

#create the docker images from mysql (naive and ontop)
docker-compose -f docker-compose.yml up -d
docker-compose -f docker-compose-ontop.yml up -d

#copy the schema and scripts to the corresponding sql and run the load scripts
for i in 1 5 10 50 100 500
do
	cp schema.sql gtfs-sql-$i/
	cp schema-ontop.sql gtfs-sql-$i/
	cd gtfs-sql-$i/
	docker exec -it mysql_gtfs$1 mysql -u root -poeg gtfs -e "source schema.sql"
	docker exec -it mysql_ontop_gtfs$1l mysql -u root -poeg gtfs -e "source schema-ontop.sql"
done

#preparation of mongodb
