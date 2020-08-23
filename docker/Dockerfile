FROM ubuntu:18.04

RUN apt-get update
RUN apt-get upgrade -y
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get install vim apt-utils pv -y
RUN apt-get install python3 python3-pip default-jre git zip csvkit -y
RUN apt-get install mysql-server -y


COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

VOLUME /output

RUN mkdir /repository

RUN apt-get install locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /repository
RUN git clone https://github.com/SDM-TIB/SDM-RDFizer.git
WORKDIR /repository/SDM-RDFizer
RUN apt-get install libpq-dev software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get install libpython3.5-dev python3.5 -y
RUN python3.5 -m pip install -r requirements.txt



WORKDIR /repository
RUN git clone https://github.com/oeg-upm/gtfs-bench.git
WORKDIR /repository/gtfs-bench

RUN service mysql start && pv -f generation/mysql_data/dump-gtfs.sql | mysql -u root

# This part is almost dynamic, forced by last commit

ARG version_sensitive_commands

RUN git pull
RUN git fetch
RUN git checkout wip

RUN echo "Rebuilding based on commit: ${version_sensitive_commands}"

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
