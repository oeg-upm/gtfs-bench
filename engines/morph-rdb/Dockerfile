FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openjdk-8-jdk vim bc less git maven wget
RUN mkdir /morph-rdb
COPY . /morph-rdb

RUN mkdir /results
RUN mkdir /data
RUN mkdir /mappings


CMD ["tail", "-f", "/dev/null"]
