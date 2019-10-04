# Morph-CSV
This folder contains the Dockerfile and configuration needed to run Morph-CSV:1.0.0 over the GTFS-Benchmark

## Morph-CSV Docker image
The created docker image is available at: [https://hub.docker.com/r/oegdataintegration/morph-csv](https://hub.docker.com/r/oegdataintegration/morph-csv)
```bash
docker run -d --name morph-csv oegdataintegration/morph-csv:1.0.0
```
## Create your own image and container
Here is an example with Ontario 

```bash
git clone https://github.com/oeg-upm/gtfs-bench
cd gtfs-bench/engines/morph-csv
git clone https://github.com/oeg-upm/morph-csv .
docker build -t morphcsv .
docker run -d --name morphcsv morphcsv

## How to run the queries in Morph-CSV
```bash
docker exec -it morphcsv './evaluate.sh'
```
