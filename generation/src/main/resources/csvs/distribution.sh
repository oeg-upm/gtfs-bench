declare -a arr=("AGENCY.csv" "TRIPS.csv" "CALENDAR.csv" "FEED_INFO.csv"  "FREQUENCIES.csv" "CALENDAR_DATES.csv" "ROUTES.csv" "STOPS.csv" "STOP_TIMES.csv" "SHAPES.csv")

apt-get install python-dev python-pip python-setuptools build-essential
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
	cp ../schema.sql .
	zip $i-json.zip *.json
	zip $i-sql.zip *.csv schema.sql
	cp ../$i.zip $i-csv.zip
	cp ../schemaDist.sql schema.sql
	zip $i-dist.zip TRIPS.csv SHAPES.csv FREQUENCIES.csv CALENDAR.csv CALENDAR_DATES.csv ROUTES.json AGENCY.json STOP_TIMES.xml STOPS.xml FEED_INFO.json schema.sql
	rm *.csv 
	rm *.xml
	rm *.json
	rm schema.sql
	cd ..
done
