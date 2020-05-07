#!/bin/bash

# Prepare env

echo "Starting MySQL container..."
sudo docker-compose -f docker-compose.yml up -d
sleep 60
echo "Importing SQL dump..."
sudo docker exec -it mysql_gtfs_vig mysql -e "source /data/dump-gtfs.sql"

