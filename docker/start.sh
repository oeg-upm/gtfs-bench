#!/bin/bash

echo "Starting auxiliar MySQL server..."
service mysql start

echo "Launching composer script..."
python3 composer/app.py

echo "Moving generated data outside docker ..."

rm -r /tmp/output/

mkdir /tmp/output/
mkdir /tmp/output/datasets/
mkdir /tmp/output/mappings/
mkdir /tmp/output/queries/

cp /repository/gtfs-bench/queries/vig/*.rq /tmp/output/queries/

cd /tmp/output/

zip -r /output/result.zip .

