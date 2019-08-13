FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openjdk-8-jdk less vim
RUN mkdir /ontop
COPY . /ontop

RUN mkdir /results
RUN mkdir /data
RUN mkdir /mappings


CMD ["tail", "-f", "/dev/null"]
