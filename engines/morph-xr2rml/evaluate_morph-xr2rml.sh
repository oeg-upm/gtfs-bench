#!/bin/bash

FILES=queries/original/*.rq
properties=properties/gtfs.properties
system_name=morph-xr2rml
mode=0

sh evaluate.sh FILES properties system_name mode