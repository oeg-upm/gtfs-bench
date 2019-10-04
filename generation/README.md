# GTFS Generation at scale for DiversiBench

## Using VIG (v1.8.0) to scale the GTFS dataset:
VIG webpage: http://ontop.github.io/vig/.

We create a SQL relational database for represeting GTFS specification and use as datasource an open instance of GTFS from a European transport authority. The dump of the database is available in the root folder. Steps for generating GTFS at scale (over MySQL database):

```bash
- git clone repository
- cd repository/data-mappings/generation
- mysql -u root -p 
	- create database gtfs;
	- use gtfs;
	- source dump-gtfs.sql;
	- \q
- vim resources/configuration.conf (edit mysql user and password)
- vim resources/gtfs.obda (edit mysql user and password)
- vim run.sh (edit your scale values at the for loop)
- chmod +x run.sh
- ./run.sh (recommend to run in background)
- cd src/main/resources/csvs
- vim distribution (change the scale values in the loop (same as run.sh))
- chmod +x distribution.sh 
- ./distribution.sh (recommend to run in background)
```
You will finally obtain a folder for each scale value (X) with 7 different zip files (the schema for sql is in /data folder, and that instances are the used in random,best and worst datasets defining the access in the mapping documents):
 - X-csv.zip (csv files)
 - X-json.zip (json files)
 - X-sql.zip (csv files)
 - X-xml.zip (xml files)
 - X-random.zip (csv, json files)
 - X-best.zip (csv, json files)
 - X-wrost.zip (csv, json files)


