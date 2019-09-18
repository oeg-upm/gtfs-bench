#!/bin/bash
properties=properties/$1

tail -n 4 $properties | wc -c | xargs -I {} truncate $properties -s -{}
