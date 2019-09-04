FROM mysql:5.7

RUN apt-get update && apt-get install -y cron vim

COPY cron-restart /etc/cron.d/cron-restart

COPY cron-script.sh /cron-script.sh

RUN chmod 777 /cron-script.sh

RUN mkdir /data

RUN touch /data/flag.txt

RUN chmod 0644 /etc/cron.d/cron-restart

RUN crontab /etc/cron.d/cron-restart

CMD cron && tail -f /var/log/cron.log