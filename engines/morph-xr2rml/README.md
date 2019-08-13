# Morph-xr2rml
This folder contains the Dockerfile needed to run Morph-xr2rml over the GTFS-Benchmark

## Morph-xr2rml Docker image
The created docker image is available at: [https://hub.docker.com/r/oegdataintegration/morph-xr2rml](https://hub.docker.com/r/oegdataintegration/morph-xr2rml)
```bash
docker pull oegdataintegration/morph-xr2rml:4.0.0
docker run -d --name morph-xr2rml oegdataintegration/morph-xr2rml:4.0.0
```

## Create your own image and container
Go to Morph-xr2rml Github and a choose your version from releases, here is an example with Morph-xr2rml
```bash
git clone https://github.com/oeg-upm/gtfs-bench
cd gtfs-bench/engines/morph-xr2rml
wget https://github.com/toledoba/morph-xr2rml/blob/master/morph-xr2rml.jar
docker build -t morph-xr2rml .
docker run -d --name morph-xr2rml morph-xr2rml
```

## How to run a query over
```bash
//ToDo
```
