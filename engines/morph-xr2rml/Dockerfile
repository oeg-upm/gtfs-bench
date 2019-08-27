FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openjdk-8-jdk vim bc less
RUN mkdir /morph-xr2rml
COPY . /morph-xr2rml

RUN mkdir /results
RUN mkdir /data
RUN mkdir /mappings
RUN mkdir /queries


CMD ["tail", "-f", "/dev/null"]
