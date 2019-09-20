#!/bin/bash

docker exec -it morph-xr2rml /morph-xr2rml/evaluate_cold.sh
docker exec -it morph-xr2rml /morph-xr2rml/evaluate_warm.sh