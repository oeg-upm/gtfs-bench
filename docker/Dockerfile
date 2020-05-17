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

WORKDIR /repository
RUN git clone https://github.com/oeg-upm/gtfs-bench.git && echo "[JUNK 1]"
WORKDIR /repository/gtfs-bench

RUN git checkout wip
RUN service mysql start && pv -f generation/mysql_data/dump-gtfs.sql | mysql -u root

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
