FROM ubuntu:latest

# Prepare system & tools
RUN apt-get update && apt-get -y upgrade && \
    apt install sudo nano openssh-server systemctl ssh wget gnupg -y && \
    apt-get install -y openjdk-11-jre-headless
# Install logstash
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/logstash-7.x.list' && \
    apt-get update && \
    apt-get install -y logstash=1:7.10.2-1
# Configuration of logging
COPY logstash.conf /etc/logstash/conf.d/logstash.conf
COPY logstash.yml /etc/logstash/logstash.yml

# Set ssh user
RUN useradd -rm -d /home/sshuser -s /bin/bash -g root -G sudo -u 1000 userssh
RUN echo 'userssh:asd123' | chpasswd

RUN mkdir /var/run/sshd

EXPOSE 22/tcp
EXPOSE 5044
EXPOSE 9600

CMD  /usr/sbin/sshd -D && /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf && systemctl start logstash