FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openjdk-8-jdk vim bc less git maven wget
RUN mkdir /morph-xr2rml
RUN wget https://github.com/toledoba/morph-xr2rml/releases/download/v4.0.0/morph-xr2rml-4.0.0.jar -P /morph-xr2rml
COPY . /morph-xr2rml

RUN mkdir /results
RUN mkdir /data
RUN mkdir /mappings


CMD ["tail", "-f", "/dev/null"]
