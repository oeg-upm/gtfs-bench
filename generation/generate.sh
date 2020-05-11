#!/bin/bash

#Move cwd to here if needed

if [ ! -z "$2" ]
then
	cd $2
fi

java -jar bin/vig-1.8.1.jar --res=resources --scale=$1

cd resources/csvs
./clean.sh
./headers.sh
zip $1.zip *.csv
rm *.csv

./distribution.sh $1
cd ../../
