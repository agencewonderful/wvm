#!/usr/bin/env bash

echo "=====================================";
echo "- Wvm - Provisionning virtual machine";
echo "=====================================";

echo "-----------------------------------------";
echo "- Wvm - Opening root session";
echo "-----------------------------------------";
sudo su -

echo "-----------------------------------------";
echo "- Wvm - Updating system";
echo "-----------------------------------------";
apt-get update -y && apt-get upgrade -y

echo "-----------------------------------------";
echo "- Wvm - Installing apache";
echo "-----------------------------------------";
apt-get -y install apache2 apache2-utils apache2-suexec libapache2-mod-fcgid
a2enmod actions rewrite fcgid #suexec

echo "-----------------------------------------";
echo "- Wvm - Installing php 5.6"
echo "-----------------------------------------";
apt-get -y install php5-apcu php5-cgi php5-cli php5-common php5-curl php5-dev php5-enchant php5-gd php5-imagick php5-intl php5-json php5-mcrypt php5-mongo php5-mysqlnd php5-odbc php5-pgsql php5-readline php5-sqlite php5-sybase php5-xdebug

echo "-----------------------------------------";
echo "- Wvm - Copying php configuration"
echo "-----------------------------------------";
cp /vagrant/config/php/php.ini /etc/php5/cgi/php.ini
cp /vagrant/config/php/fcgid.conf /etc/apache2/mods-enabled/fcgid.conf

echo "-----------------------------------------";
echo "- Wvm - Installing mariadb"
echo "-----------------------------------------";
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mariadb-server mysql-server/root_password password mysqlpwd"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password mysqlpwd"
apt-get -y install mariadb-server

echo "-----------------------------------------";
echo "- Wvm - Installing phpmyAdmin"
echo "-----------------------------------------";
export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password mysqlpwd"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password mysqlpwd"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password mysqlpwd"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
apt-get install phpmyAdmin -y

echo "-----------------------------------------";
echo "- Wvm - Copying phpmyadmin configuration"
echo "-----------------------------------------";
cp /vagrant/config/phpmyadmin/apache.conf /etc/phpmyadmin/apache.conf
cp /vagrant/config/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php

echo "-----------------------------------------";
echo "- Wvm - Configuring User Preferences"
echo "-----------------------------------------";
cp /vagrant/config/sh/.bashrc /home/vagrant/.bashrc
#cp /vagrant/config/sh/.vimrc /home/vagrant/.vimrc
cp /vagrant/config/sh/motd /etc/motd
cp /vagrant/config/sh/.bashrc_root /root/.bashrc

service apache2 restart
systemctl status apache2.service

echo "-----------------------------------------";
echo "- Wvm - Importing SQL dumps";
echo "-----------------------------------------";

sudo mysql -u root -p < /vagrant/config/db/all_databases.sql --password=mysqlpwd

echo "======================================================";
echo "- Wvm - The virtual machine provision is now finished.";
echo "======================================================";
