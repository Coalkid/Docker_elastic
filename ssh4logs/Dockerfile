FROM ubuntu:latest

RUN  apt-get update && apt-get -y upgrade && apt update -y && apt install sudo nano ncat net-tools openssh-server systemctl ssh ufw -y
RUN useradd -rm -d /home/sshuser -s /bin/bash -g root -G sudo -u 1000 userssh
RUN echo 'userssh:pass123' | chpasswd

RUN mkdir /var/run/sshd

EXPOSE 22/tcp

CMD ["/usr/sbin/sshd", "-D"]
#RUN 