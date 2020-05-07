#!/bin/bash


./prepare.sh

for i in 1 5 10 50 100 500 1000 5000
do
	./generate.sh $i
done

