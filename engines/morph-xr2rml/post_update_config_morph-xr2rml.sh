#!/bin/bash
properties=$1

tail -n 3 $properties | wc -c | xargs -I {} truncate $properties -s -{}
