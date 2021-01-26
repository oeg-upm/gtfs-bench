FROM ubuntu:18.04

RUN apt-get update
RUN apt-get upgrade -y
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get install locales vim apt-utils pv mysql-server python3 python3-pip default-jre git zip -y

VOLUME /output

RUN mkdir /repository

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /repository
RUN git clone https://github.com/oeg-upm/gtfs-bench.git
WORKDIR /repository/gtfs-bench

RUN service mysql start && pv -f generation/mysql_data/dump-gtfs-new.sql | mysql -u root && echo "grant all privileges on *.* to 'oeg'@'%';" | mysql -u root

RUN git pull
RUN git fetch
#RUN git checkout wip

RUN pip3 install -r /repository/gtfs-bench/composer/requirements.txt

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
