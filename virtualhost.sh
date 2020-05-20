#!/usr/bin/env bash

### Setting up default default variable and assign default value

action=$1
domain=$2
rootDir=$3
owner=$(who am i | awk '{print $1}')
apacheUser=$(ps -ef | egrep '(httpd|apache2|apache)' | grep -v root | head -n1 | awk '{print $1}')
email='webmaster@localhost'
enabledSites='/etc/apache2/sites-enabled/'
availableSites='/etc/apache2/sites-available/'
dirPath='/var/www/html'
domainAvailable=$availableSites$domain.conf

### Checking Up isRoot user and not given domain name

if [ "$(whoami)" != 'root' ]; then
	echo $"You dont have permission to run this script please login as root with sudo -s or use sudo"
		exit 1;
fi

while [ "$domain" == "" ]
do
	echo -e $"Please give a domain name like nayeem.test or web.dev :"
	read domain
done