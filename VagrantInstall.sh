#!/usr/bin/env bash

DBPASSWD=0000

# Update / Upgrade
sudo apt-get update
sudo apt-get -y upgrade

# Install Apache 2.5
sudo apt-get install -y apache2

# Apache Config
sudo a2enmod rewrite
echo "ServerName 127.0.0.1" | sudo tee -a /etc/apache2/conf-available/server-name.conf
sudo a2enconf server-name
rm -drf /var/www/html

# Apache Restart
sudo service apache2 restart

# Install php 5.6
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y php5.6 php5.6-zip php5.6-mysql php5.6-mbstring php5.6-xml libapache2-mod-php5.6 php5.6-mcrypt git-core php5.6-curl php5.6-gd

# PHP Config
sudo sed -i "s/;extension=php_mbstring.dll/extension=php_mbstring.dll/g" "/etc/php/5.6/apache2/php.ini"
sudo sed -i "s/;extension=php_openssl.dll/extension=php_openssl.dll/g" "/etc/php/5.6/apache2/php.ini"
sudo sed -i "s/;extension=php_pdo_mysql.dll/extension=php_pdo_mysql.dll/g" "/etc/php/5.6/apache2/php.ini"

# Activation des erreurs PHP
sudo sed -i 's/display_errors = Off/display_errors = On/g' /etc/php/5.6/apache2/php.ini
sudo sed -i 's/display_startup_errors = Off/display_startup_errors = On/g' /etc/php/5.6/apache2/php.ini

# Activation des virtualhosts fournis
sudo a2dissite 000-default
sudo a2ensite virtualhosts
service apache2 reload

# Install MySQL
sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password $DBPASSWD"
sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password $DBPASSWD"
sudo apt-get install -y mysql-server

# Install base items
sudo apt-get install -y wget build-essential zip curl

# Apache Restart
sudo service apache2 restart

sudo apt-get autoremove -y