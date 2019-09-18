# Morph-rdb
This folder contains the Dockerfile needed to run Morph-rdb over the GTFS-Benchmark

## Morph-rdb Docker image
The created docker image is available at: [https://hub.docker.com/r/oegdataintegration/morph-rdb](https://hub.docker.com/r/oegdataintegration/morph-rdb)
```bash
//docker pull oegdataintegration/morph-rdb:x.x.x
//docker run -d --name morph-rdb oegdataintegration/morph-rdb:x.x.x
```

## Create your own image and container
Go to Morph-rdb Github and a choose your version from releases, here is an example with Morph-rdb
```bash
git clone https://github.com/oeg-upm/gtfs-bench
cd gtfs-bench/engines/morph-rdb
wget https://github.com/oeg-upm/morph-rdb/releases/download/v3.12.3/morph-rdb-dist-3.12.3.jar
wget https://github.com/oeg-upm/morph-rdb/releases/download/morph-RDB_v3.9.17/dependency.zip
unzip dependency.zip
mv morph-rdb-dist-3.12.3.jar  morph-rdb.jar
docker build -t morph-rdb .
docker run -d --name morph-rdb morph-rdb
```

## How to run a query over
```bash
//ToDo
```
