#!/bin/bash

mkdir /tmp/output/
mkdir /tmp/output/datasets/
mkdir /tmp/output/mappings/
mkdir /tmp/output/queries/

echo "Starting auxiliar MySQL server..."
service mysql start > /dev/null

echo "Launching composer script..."
python3 composer/app.py

echo "Moving generated data outside docker ..."

cp /repository/gtfs-bench/queries/vig/*.rq /tmp/output/queries/

cd /tmp/output/

zip  -9 -r /output/result.zip . > /dev/null

