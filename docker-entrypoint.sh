#!/bin/bash

if [ `ls /etc/barman.d/ | wc -l` -eq 0 ]
then
  cp -ra /etc/barman.d_default/* /etc/barman.d/
else
  rm -rf /etc/barman.d/barman.d_default
  mkdir /etc/barman.d/barman.d_default
  cp -ra /etc/barman.d_default/* /etc/barman.d/barman.d_default/
fi

if [ ! -f /etc/barman.conf ]
then
  cp -ra /etc/barman.conf_default /etc/barman.conf
fi

if [ `ls /etc/openvpn/ | wc -l` -eq 0 ]
then
  cp -ra /etc/openvpn_default/* /etc/openvpn/
else
  rm -rf /etc/openvpn/openvpn_default
  mkdir /etc/openvpn/openvpn_default
  cp -ra /etc/openvpn_default/* /etc/openvpn/openvpn_default/
fi

if [ `ls /etc/ssh/ | wc -l` -eq 0 ]
then
  cp -ra /etc/ssh_default/* /etc/ssh/
else
  rm -rf /etc/ssh/ssh_default
  mkdir /etc/ssh/ssh_default
  cp -ra /etc/ssh_default/* /etc/ssh/ssh_default/
fi

#Start Syslog
/etc/init.d/rsyslog start

#Start openssh
/etc/init.d/ssh start

#Exim Update durchführen falls config angepasst wurde
update-exim4.conf
/etc/init.d/exim4 start

#Start Openvpn
/etc/init.d/openvpn start

#Start Cron
#/etc/init.d/anacron start

cron -f
