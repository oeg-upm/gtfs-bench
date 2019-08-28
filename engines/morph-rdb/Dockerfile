FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openjdk-8-jdk vim bc less
RUN mkdir /morph-rdb
COPY . /morph-rdb

RUN mkdir /results
RUN mkdir /data
RUN mkdir /mappings
RUN mkdir /queries


CMD ["tail", "-f", "/dev/null"]
