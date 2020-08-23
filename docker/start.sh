#!/bin/bash

mkdir /tmp/output/
mkdir /tmp/output/datasets/
mkdir /tmp/output/mappings/
mkdir /tmp/output/queries/

echo "Starting auxiliar MySQL server..."
service mysql start > /dev/null

echo "Launching interface..."
python3 composer/app.py


