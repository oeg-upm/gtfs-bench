#!/bin/bash

PATH=/usr/sbin:/usr/bin:/sbin:/bin


if [ ! -f "/data/flag.txt" ]; then
	service mysql restart
	touch /data/flag.txt
fi