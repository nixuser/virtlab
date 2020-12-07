#!/bin/bash

wget https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.2-1+ubuntu18.04_all.deb
dpkg -i zabbix-release_5.2-1+ubuntu18.04_all.deb
apt  update

apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-agent

# install database
apt-get -y install mariadb-server-10.1 mariadb-client-10.1
systemctl enable --now mariadb.service

mysql -uroot <<EOF
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
quit
EOF

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix zabbix
sed -i -e 's/# DBHost=localhost/DBHost=localhost/' /etc/zabbix/zabbix_server.conf
sed -i -e 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf

# httpd config
sed -e "/listen/ s/# listen/listen/" /etc/zabbix/nginx.conf
sed -e "/server_name/ s/# server_name/server_name/" /etc/zabbix/nginx.conf

systemctl enable --now zabbix-server zabbix-agent nginx php7.2-fpm
