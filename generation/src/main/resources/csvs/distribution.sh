declare -a arr=("AGENCY.csv" "TRIPS.csv" "CALENDAR.csv" "FEED_INFO.csv"  "FREQUENCIES.csv" "CALENDAR_DATES.csv" "ROUTES.csv" "STOPS.csv" "STOP_TIMES.csv" "SHAPES.csv")

sudo apt-get install python-dev python-pip python-setuptools build-essential
pip install csvkit

for i in 1 5 10 50 100 500 1000 5000
do
	unzip $i.zip -d $i
	cd $i
	for j in "${arr[@]}"
	do
		NAME=`basename $j .csv`
		csvjson $j > "$NAME.json"
		../di-csv2xml Category -i $j -o "$NAME.xml"
	done
	zip $i-json.zip *.json
	zip $i-sql.zip *.csv
	zip $i-xml.zip *.xml
	cp ../$i.zip $i-csv.zip
	zip $i-best.zip TRIPS.csv SHAPES.csv FREQUENCIES.csv CALENDAR.csv CALENDAR_DATES.csv STOP_TIMES.json STOPS.json FEED_INFO.json
	zip $i-worst.zip TRIPS.json SHAPES.csv FREQUENCIES.csv CALENDAR.csv CALENDAR_DATES.json ROUTES.csv STOPS.json FEED_INFO.json
	zip $i-random.zip TRIPS.json SHAPES.csv FREQUENCIES.json CALENDAR.csv ROUTES.csv AGENCY.csv STOP_TIMES.json
	rm *.csv 
	rm *.xml
	rm *.json
	cd ..
done
