#!/bin/bash

size=$1

echo "restarting database ..."

echo "executing docker stop gtfs${size}__mongo ..."
docker stop gtfs${size}_mongo
echo "executing docker start gtfs${size}__mongo ..."
docker start gtfs${size}__mongo
echo "tired after restaring docker, going to sleep for 60 seconds ..."
sleep 60
echo "waking up from sleep, feeling so fresh"

