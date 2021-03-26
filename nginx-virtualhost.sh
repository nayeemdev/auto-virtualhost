#!/usr/bin/env bash

### Setting up default default variable and assign default value

action=$1
domain=$2
rootDir=$3
owner=$(who am i | awk '{print $1}')
enabledSites='/etc/nginx/sites-enabled/'
availableSites='/etc/nginx/sites-available/'
dirPath='/var/www/html'
domainAvailable=$availableSites$domain

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
		grep server_name /etc/nginx/sites-enabled/* -RiI
		echo -e $"\n********************\n"
		exit;
fi

while [ "$domain" == '' ]; do
	echo -e $"Please give a domain name like nayeem.test or web.dev :"
	read domain
done

if [ "$action" == 'create' ]
	then
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

		### create virtual host rules file
		if ! echo "server {
			listen   80;
			root $rootDir;
			index index.php index.html index.htm;
			server_name $domain;
			# serve static files directly
			location ~* \.(jpg|jpeg|gif|css|png|js|ico|html)$ {
				access_log off;
				expires max;
			}
			# removes trailing slashes (prevents SEO duplicate content issues)
			if (!-d \$request_filename) {
				rewrite ^/(.+)/\$ /\$1 permanent;
			}
			# unless the request is for a valid file (image, js, css, etc.), send to bootstrap
			if (!-e \$request_filename) {
				rewrite ^/(.*)\$ /index.php?/\$1 last;
				break;
			}
			# removes trailing 'index' from all controllers
			if (\$request_uri ~* index/?\$) {
				rewrite ^/(.*)/index/?\$ /\$1 permanent;
			}
			# catch all
			error_page 404 /index.php;
			location ~ \.php$ {
				fastcgi_split_path_info ^(.+\.php)(/.+)\$;
				fastcgi_pass 127.0.0.1:9000;
				fastcgi_index index.php;
				include fastcgi_params;
			}
			location ~ /\.ht {
				deny all;
			}
		}" > $domainAvailable
		then
			echo -e $"\nOooops!! Something went wrong to create $domain host please retry.\n"
			exit;
		else
			echo -e $"\nBoooooM!! Your Virtual Host Created Successfully.\n"
		fi

		### Final touch: add in /etc/hosts site enable and nginx restart
		if ! echo "127.0.0.1	$domain" >> /etc/hosts
			then
				echo $"ERROR: Not able to write in /etc/hosts\n"
				exit;
		else
				echo -e $"Host added to /etc/hosts file \n"
		fi

		if [ "$owner" == "" ]; then
			chown -R $(whoami):www-data $rootDir
		else
			chown -R $owner:www-data $rootDir
		fi

		ln -s $domainAvailable $enabledSites$domain
		service nginx restart

		echo -e $"\n*************** Host created successfully visit your domain: http://$domain now **************************\n"
		exit;
	else
		### check whether domain already exists
		if ! [ -e $domainAvailable]; then
			echo -e $"This domain dont exists.\nPlease Try Another one"
			exit;
		else
			### Delete domain in /etc/hosts
			newhost=${domain//./\\.}
			sed -i "/$newhost/d" /etc/hosts

			### disable website
			rm $enabledSites$domain

			### restart Nginx
			service nginx restart

			### Delete virtual host rules files
			rm $domainAvailable
		fi

		### show the finished message
		echo -e $"\n*************** Your Domain deleted with host and disabled site. ***************\n"
		exit 0;
fi