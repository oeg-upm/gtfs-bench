FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openjdk-8-jdk vim bc less git maven wget
RUN mkdir /morph-xr2rml
COPY . /morph-xr2rml

RUN mkdir /results
RUN mkdir /data
RUN mkdir /mappings


CMD ["tail", "-f", "/dev/null"]
