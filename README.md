# <p align="center">Auto Virtual Host Apache</p>
Hey when we are work in new project then its annoying to create new virtual hosts checking all those boring things if not work then fixing bug on hosts file etc.... So There is a script to create your virtual host automatically. Just run script and BooooooooooooM! Host created within a second.


## Process of Installation

1. Clone or download this repo

```
git clone https://github.com/nayeemdev/auto-virtualhost-apache
```
```
cd auto-virtualhost-apache
```
2. Give permission for executing:

```
chmod +x virtualhost.sh
```

## How To Use

```
sudo sh virtualhost.sh create [domain_name] [project_directory(optional)]
```
<dl>
  <dt>Note: the default project directory is /var/www/html</dt>
</dl>

## Using Examples

```
sudo sh virtualhost.sh create nayeem.test /var/www/html/nayeem
```

## Run Host
###### GoTo Your Browser and run http://your_domain



# <p align="center">*****Extra Tips*****</p>
<p align="center">Hey here is a tips for you.</p>
<p align="center">You can run this script globally if you want just follow up these steps</p>

## Globally Use
Run this Command for copy sh file to local bin directory
```
sudo cp virtualhost.sh /usr/local/bin/virtualhost
```
For create virtual host
```
 sudo virtualhost create [[domain_name] [project_directory(optional)]
```
<dl>
  <dt>Note: the default project directory is /var/www/html</dt>
</dl>

##Global Example

```
sudo virtualhost create nayeem.test /var/www/html/nayeem
```
