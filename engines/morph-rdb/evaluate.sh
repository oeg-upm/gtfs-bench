#!/bin/bash

docker exec -it morph-rdb /morph-rdb/evaluate_cold.sh
docker exec -it morph-rdb /morph-rdb/evaluate_warm.sh