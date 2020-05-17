#!/bin/bash

docker build --tag oegdataintegration/gtfs-bench:"$(git log --format="%h" -n 1)" --tag oegdataintegration/gtfs-bench:latest .
docker push oegdataintegration/gtfs-bench:latest
