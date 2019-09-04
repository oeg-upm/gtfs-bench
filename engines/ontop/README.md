# Ontop-cli
This folder contains the Dockerfile and properties needed to run Ontop-3.0.0-beta over the GTFS-Benchmark

## Ontop Docker image
The created docker image is available at: [https://hub.docker.com/r/oegdataintegration/ontop](https://hub.docker.com/r/oegdataintegration/ontop)
```bash
docker run -d --name ontop oegdataintegration/ontop:3.0.0
```

## Create your own image
Go to Ontop Github and a choose your version from releases, here is an example with Ontop-3.0.0-beta:
```bash
git clone https://github.com/oeg-upm/gtfs-bench
cd gtfs-bench/engines/ontop
wget https://github.com/ontop/ontop/releases/download/ontop-3.0.0-beta-3/ontop-cli-3.0.0-beta-3.zip
unzip ontop-cli-3.0.0-beta-3.zip
cd jdbc
wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.17/mysql-connector-java-8.0.17.jar
cd ..
docker build -t ontop .
```

## How to run a query over
```bash
docker exec -it ontop /ontop/ontop query -m /mappings/gtfs-rdb.obda -p /ontop/properties/gtfs-SIZE.properties -q /queries/queryX.rq
```
