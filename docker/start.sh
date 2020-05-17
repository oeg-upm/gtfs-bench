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

mv /repository/gtfs-bench/generation/output/* /tmp/output/datasets/

cp /repository/gtfs-bench/mappings/gtfs-csv.rml.ttl /tmp/output/mappings/
cp /repository/gtfs-bench/mappings/gtfs-json.rml.ttl /tmp/output/mappings/
cp /repository/gtfs-bench/mappings/gtfs-mongo.rml.ttl /tmp/output/mappings/
cp /repository/gtfs-bench/mappings/gtfs-xml.rml.ttl /tmp/output/mappings/
cp /repository/gtfs-bench/mappings/gtfs-best.rml.ttl /tmp/output/mappings/
cp /repository/gtfs-bench/mappings/gtfs-worst.rml.ttl /tmp/output/mappings/

cp /repository/gtfs-bench/queries/*.rq /tmp/output/queries/

zip -rj /output/result.zip /tmp/output/*

