declare -a arr=("AGENCY.csv" "TRIPS.csv" "CALENDAR.csv" "FEED_INFO.csv"  "FREQUENCIES.csv" "CALENDAR_DATES.csv" "ROUTES.csv" "STOPS.csv" "STOP_TIMES.csv" "SHAPES.csv")

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

zip $1-best.zip TRIPS.csv SHAPES.csv FREQUENCIES.csv CALENDAR.csv CALENDAR_DATES.csv STOP_TIMES.json STOPS.json FEED_INFO.json
zip $1-worst.zip TRIPS.json SHAPES.csv FREQUENCIES.csv CALENDAR.csv CALENDAR_DATES.json ROUTES.csv STOPS.json FEED_INFO.json

rm *.csv 
rm *.xml
rm *.json
cd ..

rm $1.zip

mv $1 ../../output/
