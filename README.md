# Docker container for barman

This container also provides:
 * openvpn
 * ssh server
 * exim4
to connect to the target databases via openvpn.

## Configuration
 
 ### Volume Configuration
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
  
 ### Exim4 configuration
  For barman to send mails exim4 is used.
 #### update-exim3.conf.conf
 Create a file _update-exim3.conf.conf_ with the following input:
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
 
 #### password.client
 Create a file _password.client_ with the following input:
 ```
 mx.example.domain:user:passwd
 ```
 Adopt _mx.example.domain_ to target your mailserver and change _user_ and _passwd_ to the username and password to use for the authentication with the mailserver.
