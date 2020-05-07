# GTFS Generation at scale for the Madrid-GTFS-Bench

## Using VIG (v1.8.0) to scale the GTFS dataset:
VIG webpage: http://ontop.github.io/vig/.

We create a SQL relational database for represeting GTFS specification and use as datasource an open instance of GTFS from a European transport authority. The dump of the database is available in the root folder. Steps for generating GTFS at scale (over MySQL database):

### Requisites

- Java JRE
- Docker and docker-compose
- csvkit (use pip3 or apt installer)

### Preparation

On this repository:

```
cd generation
./prepare.sh
```

This will launch a docker container and import the SQL dump on a MySQL server

### Single size generation

```
./generate.sh [SIZE]
```

### Multiple size generation

Edit the run.sh loop, then

```
./run.sh
```

### Output

You will finally obtain a folder for each scale value (X) with 7 different zip files (the schema for sql is in /data folder, and that instances are the used in random,best and worst datasets defining the access in the mapping documents):
 - X-csv.zip (csv files)
 - X-json.zip (json files)
 - X-sql.zip (csv files)
 - X-xml.zip (xml files)
 - X-random.zip (csv, json files)
 - X-best.zip (csv, json files)
 - X-wrost.zip (csv, json files)


