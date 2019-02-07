FROM debian:stretch

MAINTAINER foxcris

#locale richtig setzen
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales && apt-get clean
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF8

#automatische aktualiserung installieren + basic tools
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y nano less wget gnupg anacron unattended-upgrades apt-transport-https crudini htop sudo&& apt-get clean

#repository fuer barman hinzufuegen
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' > /etc/apt/sources.list.d/pgdg.list

#install barman
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y barman  && apt-get clean

#install additional packages for barman
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-client rsync postgresql-client-9.4 postgresql-client-9.5 postgresql-client-9.6  && apt-get clean

#install openvpn
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y openvpn && apt-get clean

#configure openvpn
RUN sed -i 's/.*#AUTOSTART="all".*/AUTOSTART="all"/' /etc/default/openvpn

#install rsyslog
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y rsyslog && apt-get clean

#install openssh
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server && apt-get clean

#backup default directories
RUN mv /etc/barman.conf /etc/barman.conf_default
RUN mv /etc/barman.d /etc/barman.d_default
RUN mkdir /etc/barman.d
RUN mv /etc/openvpn /etc/openvpn_default
RUN mkdir /etc/openvpn
RUN mv /etc/ssh /etc/ssh_default
RUN mkdir /etc/ssh

VOLUME /etc/barman.d
VOLUME /etc/openvpn
VOLUME /etc/ssh
VOLUME /var/log
VOLUME /var/lib/barman
VOLUME /var/spool/cron/crontabs

#EXPOSE 80 443 3000 5665 8000
COPY docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
