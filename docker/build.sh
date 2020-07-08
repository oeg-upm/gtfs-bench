#!/bin/bash

#--tag oegdataintegration/gtfs-bench:"$(git log --format="%h" -n 1)"
docker build --build-arg versions_sensitive_commands="$(git log --format="%h" -n 1)" --tag oegdataintegration/gtfs-bench:latest .
docker push oegdataintegration/gtfs-bench:latest
