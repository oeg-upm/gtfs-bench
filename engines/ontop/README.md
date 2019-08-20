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
unzip ontop-cli-3.0.0-beta-3.zip -d .
docker build -t ontop .
```

## How to run a query over
```bash
docker exec -it ontop /ontop/ontop query -m /mappings/r2rmlmapping.ttl -p /ontop/properties/propertiesFile.properties -q /queries/queryX.rq
```
