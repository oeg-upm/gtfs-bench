#!/bin/bash


cp ../data/gtfs-csv-1/* ../data/

for i in 1 2 3 4 5
do
	docker exec -it morph-csv /run.sh /original-config.json
	docker exec -it morph-csv rm -rf /morphcsv/output
done

for i in 1 5 10 50 100 500
do
	for i in 1 5 10 50 100 500
	do
		cp ../data/gtfs-csv-$i/* ../data/
		docker exec -it morph-csv /run.sh /original-config.json
		docker exec -it morph-csv rm -rf /morphcsv/output
	done
done

cd ../data
rm CALENDAR_DATES.csv AGENCY.csv STOPS.csv SHAPES.csv ROUTES.csv FREQUENCIES.csv CALENDAR.csv STOP_TIMES.csv FEED_INFO.csv TRIPS.csv
