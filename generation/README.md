# GTFS Generation at scale for the Madrid-GTFS-Bench

## Using VIG (v1.8.0) to scale the GTFS dataset:
VIG webpage: http://ontop.github.io/vig/.

We create a SQL relational database for represeting GTFS specification and use as datasource an open instance of GTFS from a European transport authority. The dump of the database is available in the root folder. Steps for generating GTFS at scale (over MySQL database):

### Requisites

- Java JRE
- Docker and docker-compose
- csvkit (use pip3 or apt installer)

### Up and Running

On this repository:

```
cd generation
./run.sh
```

This will launch a docker container and import the SQL dump on a MySQL server. Then it will create and distribute the datasets using the scales of the experimental evaluation shown in the paper (1, 5, 10, 50, 100, 500).

### Output

You will finally obtain a folder for each scale value (1, 5, 10, 50, 100, 500) with 4 different zip files (copy them to the loading-scripts folder):
 - X-csv.zip (csv files)
 - X-json.zip (json files)
 - X-sql.zip (csv files)
 - X-xml.zip (xml files)


