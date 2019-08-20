FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openjdk-8-jdk nano less git maven
RUN mkdir /morphcsv
COPY . /morphcsv

RUN mkdir /results
RUN mkdir /data
RUN mkdir /mappings
RUN mkdir /queries
RUN mkdir /morphcsv/output

CMD ["tail", "-f", "/dev/null"]
