# Docker container for barman

This container also provides:
 * openvpn
 * ssh server
 * exim4
to connect to the target databases via openvpn.

## Configuration
 
### Configuration files, log files, buisness data
The following directories can be loaded from the host to keep the data and configuration files out of the container:

 | PATH in container | Description |
 | ---------------------- | ----------- |
 | /etc/barman.d | Directory of all barman configurations. If this directory is empty on start a default barman configuration is provided. |
 | /etc/barman.conf (File) | Main Barmanc Configuration. If the file does not exist on start a default barman configuration file is provided. | 
 | /etc/openvpn/ | Directory of the openvpn configuration files. |
 | /etc/ssh/ | Directory of the ssh server configuration. If this directory is empty on start a default ssh server configuration is provided. |
 | /etc/exim4/update-exim3.conf.conf | exim4 configuration file |
 | /etc/exim4/password.client | exim4 credentials file |
 | /var/log | Logging directory |
 | /var/lib/barman | Storage directroy of barman |
 | /var/spool/cron/crontabs | Directory of cronfiles to automatically start barman jobs |

## Container Tags

 | Tag name | Description |
 | ---------------------- | ----------- |
 | latest | Latest stable version of the container |
 | stable | Latest stable version of the container |
 | dev | latest development version of the container. Do not use in production environments! |
 
## Usage

To run the container and store the data and configuration on the local host run the following commands:
1. Create storage directroy for the configuration files, log files and data. Also create a directroy to store the necessary script to create the docker container and replace it (if not using eg. watchtower)
```
mkdir /srv/docker/barman
mkdir /srv/docker-config/barman
```

2. Exim4 configuration
For barman to send mails exim4 is used. Create the following file:
```
touch /srv/docker/barman/etc/exim4/update-exim3.conf.conf
```
Add the following content:
```
# /etc/exim4/update-exim4.conf.conf
dc_eximconfig_configtype='satellite'
dc_other_hostnames='localhost'
dc_local_interfaces='127.0.0.1'
dc_readhost='localhost'
dc_relay_domains=''
dc_minimaldns='false'
dc_relay_nets=''
dc_smarthost='mx.example.domain'
CFILEMODE='644'
dc_use_split_config='true'
dc_hide_mailname='true'
dc_mailname_in_oh='true'
dc_localdelivery='mail_spool'
```
Change the parameter "dc_smarthost" to target your mailserver to use.

3. Create password file for exim for mail delivery
```
touch /srv/docker/barman/etc/exim4/password.client
```
Add the following content:
```
mx.example.domain:user:passwd
```
Adopt _mx.example.domain_ to target your mailserver and change _user_ and _passwd_ to the username and password to use for the authentication with the mailserver.


4. Create the docker container and configure the docker networks for the container. I always create a script for that and store it under
```
touch /srv/docker-config/barman/create.sh
```
Content of create.sh:
```
#!/bin/bash

docker pull foxcris/docker-barman
docker create\
 --restart always\
 --name barman\
 --volume "/srv/docker/barman/etc/barman.d:/etc/barman.d"\
 --volume "/srv/docker/barman/etc/barman.conf:/etc/barman.conf"\
 --volume "/srv/docker/barman/etc/openvpn:/etc/openvpn"\
 --volume "/srv/docker/barman/etc/ssh:/etc/ssh"\
 --volume "/srv/docker/barman/etc/exim4/update-exim3.conf.conf:/etc/exim4/update-exim3.conf.conf"\
 --volume "/srv/docker/barman/etc/exim4/password.client:/etc/exim4/password.client"\
 --volume "/srv/docker/barman/var/log:/var/log"\
 --volume "/srv/docker/barman/var/lib/barman:/var/lib/barman"\
 --volume "/srv/docker/barman/var/spool/cron/crontabs:/var/spool/cron/crontabs"\
 foxcris/docker-barman
```

5. Create replace.sh to install/update the container. Store it in
```
touch /srv/docker-config/barman/replace.sh
```
```
#/bin/bash
docker stop barman
docker rm barman
./create.sh
docker start barman
```
