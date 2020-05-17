#!/bin/bash

#Move cwd to here if needed

if [ ! -z "$2" ]
then
	cd $2
fi

java -jar bin/vig-1.8.1.jar --res=resources --scale=$1 > /dev/null

cd resources/csvs
./clean.sh > /dev/null
./headers.sh > /dev/null


#zip $1.zip *.csv > /dev/null
#rm *.csv 

#./distribution.sh $1 > /dev/null
#cd ../../
