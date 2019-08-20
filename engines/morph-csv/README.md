# Morph-CSV
This folder contains the Dockerfile and configuration needed to run Morph-CSV:1.0.0 over the GTFS-Benchmark

## Morph-CSV Docker image
The created docker image is available at: [https://hub.docker.com/r/oegdataintegration/morph-csv](https://hub.docker.com/r/oegdataintegration/morph-csv)
```bash
docker run -d --name morph-csv oegdataintegration/morph-csv:1.0.0
```

## Create your own image
Go to Morph-CSV Github and a choose your version from releases, here is an example with Morph-CSV-1.0.0:
```bash
git clone https://github.com/oeg-upm/gtfs-bench
cd gtfs-bench/engines/morph-csv
wget https://github.com/oeg-upm/morph-csv/archive/1.0.0.zip
unzip 1.0.0.zip
rm morph-csv-1.0.0/Dockerfile 
cp -R morph-csv-1.0.0/* .
mvn clean compile assembly:single 
cp target/morph-csv-1.0-jar-with-dependencies.jar morph-csv.jar
docker build -t morph-csv .
```

## How to run a query over Morph-CSV
```bash
docker exec -it morph-csv /morph-csv/run.sh /morph-csv/[original|vig]-config.json
```
