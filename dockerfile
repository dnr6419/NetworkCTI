FROM ubuntu:bionic

# set the version you want
ENV FILEBEAT_VERSION=7.13.0

RUN apt-get install curl wget -y 

RUN curl https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -o /filebeat.tar.gz && \
    tar xvf filebeat.tar.gz && \
    rm filebeat.tar.gz && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64 filebeat 

USER root
WORKDIR /filebeat/

ADD ./filebeat.sh /filebeat/filebeat.sh
RUN chmod 777 filebeat.sh
# filebeat.yml 옮기기 & suricata.yml 옮기기
ADD ./filebeat.yml /filebeat/filebeat.yml
ADD ./suricata.yml /filebeat/modules.d/suricata.yml

RUN chmod go-w /filebeat/filebeat.yml
RUN chmod go-w /filebeat/modules.d/suricata.yml

CMD [ "/filebeat/filebeat.sh" ]