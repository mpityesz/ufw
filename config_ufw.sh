#!/bin/bash


## Install
#apt install -y ufw


## Reset
ufw --force reset


## Basic + SSH
ufw default deny incoming
ufw default allow outgoing

ufw allow dns

ufw allow from 79.172.195.155 to any port 22
ufw allow from 87.229.111.223 to any port 22
ufw allow from 87.229.111.226 to any port 22
ufw allow from 80.77.123.131 to any port 22


## ISP + Web
ufw allow 8888/tcp
ufw allow 8081/tcp
ufw allow http/tcp
ufw allow https/tcp


## FTP-like
#ufw allow sftp ## port number: 22
ufw allow ftps
ufw allow 2121
ufw allow 20000:20500/tcp


## Mail
ufw allow "Dovecot IMAP"
ufw allow "Dovecot Secure IMAP"
ufw allow "Postfix"
ufw allow "Postfix SMTPS"
ufw allow "Postfix Submission"
ufw allow "Dovecot POP3"
ufw allow "Dovecot Secure POP3"


## Start
ufw enable
ufw status
