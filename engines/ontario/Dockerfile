FROM kemele/ontario:0.3

RUN apt-get update && apt-get install -y openjdk-8-jdk vim bc less
COPY . /Ontario

CMD ["tail", "-f", "/dev/null"]
