#!/bin/bash


docker exec -it ontop /ontop/evaluate_cold.sh
docker exec -it ontop /ontop/evaluate_warm.sh