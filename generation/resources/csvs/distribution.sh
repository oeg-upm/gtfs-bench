declare -a arr=("AGENCY.csv" "TRIPS.csv" "CALENDAR.csv" "FEED_INFO.csv"  "FREQUENCIES.csv" "CALENDAR_DATES.csv" "ROUTES.csv" "STOPS.csv" "STOP_TIMES.csv" "SHAPES.csv")

#Move cwd to here if needed


if [ ! -z "$2" ]
then
	cd $2
fi

unzip $1.zip -d $1

cd $1

for j in "${arr[@]}"
do
	NAME=`basename $j .csv`
	csvjson $j > "$NAME.json"
	../di-csv2xml Category -i $j -o "$NAME.xml"
done

zip $1-json.zip *.json
zip $1-sql.zip *.csv
zip $1-xml.zip *.xml

cp ../$1.zip $1-csv.zip


rm *.csv 
rm *.xml
rm *.json
cd ..

rm $1.zip

rm -r ../../output/$1/
mv $1 ../../output/
