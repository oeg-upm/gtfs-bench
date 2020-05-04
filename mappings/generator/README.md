# Mapping generator

## config.json

Source of individual TripleMaps can be specified on the config.json file, with the following sintaxis:

```
{
	"entities": [
		{
			"id": 0,
			"name": "AGENCY",
			"map": "partial/agency.ttl",
			"source": {
				"type": "mysql",
				"connection": {
					"user": "root",
					"pass": "oeg",
					"dsn": "jdbc:mysql://localhost:3306/gtfs",
					"driver": "com.mysql.cj.jdbc.Driver"
				},
				"table": "AGENCY"
			}
		},
		
		{
			"id": 1,
			"name": "TRIPS",
			"map": "partial/trips.ttl",
			"source": {
				"type": "csv",
				"file": "source.csv"
			}	
		}, 
		
		{
			"id": 2,
			"name": "STOPS",
			"map": "partial/stops.ttl",
			"source": {
				"type": "json",
				"file": "source.json"
			}	
		}, 
		
		[...]
		
}
```

## app.py

Run the script using:

```
./app.py -c config.json -o test.ttl -f turtle
```
