#!/usr/bin/env bash

### Setting up default default variable and assign default value

action=$1
domain=$2
rootDir=$3
owner=$(who am i | awk '{print $1}')
enabledSites='/etc/nginx/sites-enabled/'
availableSites='/etc/nginx/sites-available/'
dirPath='/var/www/html'
domainAvailable=$availableSites$domain.conf