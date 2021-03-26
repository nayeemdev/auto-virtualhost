# <p align="center">Auto Virtual Host Apache/nginx</p>
Hey when we are work in new project then its annoying to create new virtual hosts checking all those boring things if not work then fixing bug on hosts file etc.... So There is a script to create your virtual host automatically. Just run script and BooooooooooooM! Host created within a second.

![apache-virtualhost](https://user-images.githubusercontent.com/40033062/92646491-589a0c00-f308-11ea-90e5-102e617e3bb7.gif)


## Features
* Create New Virtualhost
* Delete an Existing Host
* View all List of Existing Host
* Compatible with nginx and apache

## Process of Installation

1. Clone or download this repo

```
git clone https://github.com/nayeemdev/auto-virtualhost
```
```
cd auto-virtualhost
```
2. Give permission for executing(Different For nginx and apache):

```
### For Apache
sudo chmod +x apache-virtualhost.sh

### For nginx
sudo chmod +x nginx-virtualhost.sh
```
# <p align="center">*****Local Use*****</p>

```
### For Apache
sudo ./apache-virtualhost.sh [create/delete/list] [domain_name] [your_project_full_directory_path]

### For nginx
sudo ./nginx-virtualhost.sh [create/delete/list] [domain_name] [your_project_full_directory_path]
```

## Using Examples (Different For nginx and apache)

```
### For Apache
sudo ./virtualhost.sh create nayeem.test /var/www/html/nayeem

### For nginx
sudo ./virtualhost.sh create nayeem.test /var/www/html/nayeem
```

## Run Host
#### GoTo Your Browser and run http://your_domain


# <p align="center">*****Global Use*****</p>
<p align="center">You can run this script globally if you want just follow up these steps</p>

## Globally Use
Give permission for executing:
```
### For Apache
sudo chmod +x apache-virtualhost.sh

### For nginx
sudo chmod +x nginx-virtualhost.sh
```

Run this Command for copy sh file to local bin directory
```
### For Apache
sudo cp apache-virtualhost.sh /usr/local/bin

### For nginx
sudo cp nginx-virtualhost.sh /usr/local/bin
```
For create virtual host
```
### For Apache
sudo apache-virtualhost [create/delete] [domain_name}[your_project_full_directory_path]

### For nginx
sudo apache-virtualhost [create/delete] [domain_name}[your_project_full_directory_path]
```


## Global Example

```
### For Apache
sudo apache-virtualhost create nayeem.test /var/www/html/nayeem

### For nginx
sudo nginx-virtualhost create nayeem.test /var/www/html/nayeem
```


## Want to contribute?
<p>Clone this repo add/change what you want and send a pull request. ##Happy Coding##</p>
