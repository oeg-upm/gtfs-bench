# Ontario
This folder contains the Dockerfile needed to run Ontario over the GTFS-Benchmark

## Ontario Docker image
The created docker image is available at: [https://hub.docker.com/r/oegdataintegration/ontario](https://hub.docker.com/r/oegdataintegration/ontario)
```bash
docker oegdataintegration/ontario:0.3
docker run -d --name ontario oegdataintegration/ontario:0.3
```

## Create your own image and container
Here is an example with Ontario 

```bash
git clone https://github.com/oeg-upm/gtfs-bench
cd gtfs-bench/engines/ontario
docker build -t ontario .
docker run -d --name ontario ontario

```
## How to run a query over

```bash
//ToDo
```
