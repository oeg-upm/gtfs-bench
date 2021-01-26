#!/bin/bash

docker build --no-cache --tag oegdataintegration/gtfs-bench:testing .
docker push oegdataintegration/gtfs-bench:testing
