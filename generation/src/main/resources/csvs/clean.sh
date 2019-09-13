#!/bin/bash

# ` to '
sed -i 's/`/,/g' *.csv

#\N to ,,
sed -i 's/\\N//g' *.csv

#HH:MM:SS.0
sed -i -r 's/[0-9]{2}\:[0-9]{2}\:[0-9]{2}\.[0]{1}//g' *.csv

#Remove space
sed -i 's/ //g' *.csv

#####################
# Clean colums
#####################

#CALENDAR

awk -F "," '{print $1","$2-1","$3-1","$4-1","$5-1","$6-1","$7-1","$8-1"," $9"," $10}' CALENDAR.csv> tmp.txt
cat tmp.txt > CALENDAR.csv

#ROUTES

awk -F "," '{print $1","$2-1","$3","$4","$5","$6-1","$7","$8"," $9"," $10}' ROUTES.csv> tmp.txt
cat tmp.txt> ROUTES.csv

#STOP_TIMES
awk -F "," '{print $1","$2","$3","$4","$5","$6 "," $7-1 "," $8-1 ","$9}'  STOP_TIMES.csv > tmp.txt
cat tmp.txt >STOP_TIMES.csv

#STOPS
awk -F "," '{print $1","$2","$3","$4","$5","$6","$7","$8 "," $9-1 "," $10","$11"," $12-1}' STOPS.csv >tmp.txt
cat  tmp.txt > STOPS.csv


#TRIPS
awk -F "," '{print $1","$2","$3","$4","$5","$6-1","$7","$8 "," $9-1}' TRIPS.csv > tmp.txt
cat tmp.txt > TRIPS.csv

#CALENDAR_DATES
awk -F "," '{print $1","$2","$3-1}' CALENDAR_DATES.csv >tmp.txt
cat tmp.txt > CALENDAR_DATES.csv

#FREQUENCIES
awk -F "," '{print $1","$2","$3","$4"," 0}' FREQUENCIES.csv > tmp.txt
cat tmp.txt >FREQUENCIES.csv

rm tmp.txt
