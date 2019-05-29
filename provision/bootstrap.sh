#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Install Prerequisites
apt-get install curl git software-properties-common

add-apt-repository -y ppa:chris-lea/redis-server
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirrors.coreix.net/mariadb/repo/10.3/ubuntu bionic main'
add-apt-repository -y ppa:ondrej/php
wget -qO - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

apt-get update

echo -e 'Installing Redis';
echo -e '================';

apt-get install -y redis-server redis-tools
systemctl enable redis-server

echo -e 'Installing MariaDB';
echo -e '==================';

apt-get install -y mariadb-client mariadb-server

echo -e 'Installing PHP 7.2';
echo -e '==================';

apt-get install -y php7.2-fpm php7.2-cli php7.2-curl php7.2-json php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-soap php7.2-xml php7.2-xmlrpc php7.2-zip
apt-get install -y php-imagick php-redis php-xdebug

cp /srv/config/www.conf /etc/php/7.2/fpm/pool.d/www.conf
cp /srv/config/php/xdebug.ini /etc/php/7.2/mods-available/xdebug.ini

echo -e 'Installing Elasticsearch';
echo -e '========================';

apt-get install -y elasticsearch
service elasticsearch start

systemctl enable elasticsearch

echo -e 'Installing OpenResty';
echo -e '====================';

apt-get install -y openresty

mkdir -p /var/log/nginx

cp /srv/config/openresty.conf /etc/openresty/nginx.conf

ln -s /srv/config/sites /etc/openresty/sites;

apt-get clean
apt-get autoremove -y

echo -e 'Installing Composer';
echo -e '===================';

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

mv composer.phar /usr/local/bin/composer

service openresty restart
service php7.2-fpm restart

source /srv/provision/wordpress.sh
source /srv/provision/utilities.sh