#!/bin/bash

echo "Provisioning virtual machine..."

# Git
echo "Installing Git"
apt-get install git -y > /dev/null

# Subversion
echo "Installing Subversion"
apt-get install subversion -y > /dev/null

#aphpkb
echo "Checking out Aphpkb"
svn checkout https://svn.code.sf.net/p/aphpkb/code/ aphpkb-code


# PHP & Apache2
echo "Installing PHP & Apache2"
apt-get update > /dev/null
apt-get -y install apache2
apt-get -y install php7.0 libapache2-mod-php7.0
systemctl restart apache2

echo "Installing PHP extensions"
apt-get -y install php7.0-mysql php7.0-curl php7.0-gd php7.0-intl php-pear php-imagick php7.0-imap php7.0-mcrypt php-memcache  php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl php7.0-mbstring php-gettext

#Exporting aphpkb to DocumentRoot
echo 'Installing Aphpkb to DocRoot'
svn export aphpkb-code /var/www/html/aphpkb

# MySQL 
echo "Preparing MySQL"
apt-get install debconf-utils -y > /dev/null
debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"

echo "Installing MySQL"
apt-get install mysql-server -y > /dev/null

sudo mysql -e "CREATE DATABASE IF NOT EXISTS akb_ubuntu; CREATE USER 'ubuntu'@'%' IDENTIFIED BY 'ubuntu'; GRANT ALL PRIVILEGES ON akb_ubuntu.* TO 'ubuntu'@'%'; FLUSH PRIVILEGES;" --password=1234

sudo mysql -e -pubuntu -u ubuntu akb_ubuntu < /var/www/html/aphpkb/docs/akb.sql 

echo "Finished provisioning."

