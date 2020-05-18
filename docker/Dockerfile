FROM ubuntu:18.04

RUN apt-get update
RUN apt-get upgrade -y
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get install vim apt-utils pv -y
RUN apt-get install python3 python3-pip default-jre git zip csvkit -y
RUN apt-get install mysql-server -y

RUN pip3 install rdflib PyInquirer termcolor

VOLUME /output

RUN mkdir /repository

RUN apt-get install locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /repository
RUN git clone https://github.com/oeg-upm/gtfs-bench.git
WORKDIR /repository/gtfs-bench

RUN service mysql start && pv -f generation/mysql_data/dump-gtfs.sql | mysql -u root

# This part is almost dynamic, forced by last commit

ARG versions_sensitive_commands

RUN git pull
RUN git fetch
RUN git checkout wip

RUN echo "Rebuilding based on commit: ${versions_sensitive_commands}"

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
