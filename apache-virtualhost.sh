#!/usr/bin/env bash

### Setting up default default variable and assign default value

action=$1
domain=$2
rootDir=$3
port=${4:-80}  # Default port is 80 if not specified
owner=$(who am i | awk '{print $1}')
apacheUser=$(ps -ef | egrep '(httpd|apache2|apache)' | grep -v root | head -n1 | awk '{print $1}')
email='webmaster@localhost'
enabledSites='/etc/apache2/sites-enabled/'
availableSites='/etc/apache2/sites-available/'
dirPath='/var/www/html'
domainAvailable=$availableSites$domain.conf

### Function to check if port is already in use
function is_port_in_use {
    netstat -tuln | grep :$1 > /dev/null
    return $?
}

### Checking Up isRoot user and not given domain name

if [ "$(whoami)" != 'root' ]; then
	echo -e $"\nYou dont have permission to run this script please login as root with sudo -s or use sudo.\n"
		exit 1;
fi

if [ "$action" != 'create' ] && [ "$action" != 'delete' ] && [ "$action" != 'list' ]
	then
		echo -e $"\nPlease Use create or delete or list as action.\n"
		exit 1;
fi
if [ "$action" == 'list' ]
	then
		echo -e $"\n********************\n"
		### command for list
		a2query -s
		echo -e $"\n********************\n"
		exit;
fi
while [ "$domain" == '' ]; do
	echo -e $"Please give a domain name like nayeem.test or web.dev :"
	read domain
done

if [ "$action" == 'create' ]; then

### Check if port is already in use
    if is_port_in_use $port; then
        echo -e $"\nError: Port $port is already in use. Please use a different port.\n"
        exit 1
    fi

                ### check if domain already exists
                if [ -e $domainAvailable ]; then
                        echo -e $"\nHey, this domain is already exist in host please retry with new one.\n"
                        exit;
                fi

                ### checking up directory is exist if not then create one with permison
                if ! [ -d $rootDir ]; then
                        mkdir $rootDir
                        chmod 755 $rootDir
                fi

                ### Creating virtual host conf file with rules
                if ! echo "
                Listen $port
		NameVirtualHost *:$port
                <VirtualHost *:$port>
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
                        echo -e $"\nOooops!! Something went wrong to create $domain host please retry.\n"
                        exit;
                else
                        echo -e $"\nBoooooM!! Your Virtual Host Created Successfully.\n"
                fi

                ### Final touch: add in /etc/hosts site enable and apache restart
                if ! echo "127.0.0.1	$domain" >> /etc/hosts
                then
                        echo $"ERROR: Not able to write in /etc/hosts\n"
                        exit;
                else
                        echo -e $"Host added to /etc/hosts file \n"
                fi

                a2ensite $domain

                /etc/init.d/apache2 reload

                echo -e $"\n*************** Host created successfully visit your domain: http://$domain:$port now **************************\n"
                exit;
        else
                ### check whether domain already exists
		if ! [ -e $domainAvailable ]; then
			echo -e $"\nThe domain name you provide is not exist in host please use an existing domain.\n"
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
		echo -e $"\n*************** Your Domain deleted with host and disabled site. ***************\n"
		exit 0;
fi
