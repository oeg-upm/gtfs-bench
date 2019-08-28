#!/bin/bash

size=$1

echo "restarting database ..."
#sudo service mysql restart

echo "executing docker stop gtfs${size}_mysql ..."
docker stop gtfs${size}_mysql
echo "executing docker start gtfs${size}_mysql ..."
docker start gtfs${size}_mysql
echo "tired after restaring docker, going to sleep for 60 seconds ..."
sleep 30
echo "waking up from sleep, feeling so fresh"

