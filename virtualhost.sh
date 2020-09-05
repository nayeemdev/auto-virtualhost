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

if [ "$action" != 'create' ] && [ "$action" != 'delete' ]
	then
		echo $"Please Use create or delete as action."
		exit 1;
fi

while [ "$domain" == '' ]; do
	echo -e $"Please give a domain name like nayeem.test or web.dev :"
	read domain
done

if [ "$action" == 'create' ]; then
                ### check if domain already exists
                if [ -e $domainAvailable ]; then
                        echo -e $"Hey this domain is already exist in directory please retry eith new one."
                        exit;
                fi

                ### checking up directory is exist if not then create one with permison
                if ! [ -d $rootDir ]; then
                        mkdir $rootDir
                        chmod 755 $rootDir
                fi

                ### Creating virtual host conf file with rules
                if ! echo "
                <VirtualHost *:80>
                        ServerAdmin $email
                        ServerName $domain
                        ServerAlias $domain
                        DocumentRoot $rootDir
                        ErrorLog /var/log/apache2/$domain-error.log
                        LogLevel error
                        CustomLog /var/log/apache2/$domain-access.log combined
                        <Directory />
                                AllowOverride All
                        </Directory>
                        <Directory $rootDir>
                                Options Indexes FollowSymLinks MultiViews
                                AllowOverride all
                                Require all granted
                        </Directory>
                </VirtualHost>" > $domainAvailable
                then
                        echo -e $"Oooops!! Something went wrong to create $domain host please retry"
                        exit;
                else
                        echo -e $"BoooooM!! Virtual Host Created Successfully.\n"
                fi

                ### Final touch: add in /etc/hosts site enable and apache restart
                if ! echo "127.0.0.1	$domain" >> /etc/hosts
                then
                        echo $"ERROR: Not able to write in /etc/hosts"
                        exit;
                else
                        echo -e $"Host added to /etc/hosts file \n"
                fi

                a2ensite $domain

                /etc/init.d/apache2 reload

                echo -e $"**************** Host created successfully visit your domain: http://$domain now **************************"
                exit;
        else
                ### check whether domain already exists
		if ! [ -e $domainAvailable ]; then
			echo -e $"This domain does not exist.\nPlease check the domain name"
			exit;
		else
			### Delete domain in /etc/hosts
			newhost=${domain//./\\.}

			sed -i "/$newhost/d" /etc/hosts

			### disable website
			a2dissite $domain

			### restart Apache
			/etc/init.d/apache2 reload

			### Delete virtual host rules files
			rm $domainAvailable
		fi
		### show the finished message
		echo -e $"Complete!\nYou just removed Virtual Host $domain"
		exit 0;
fi