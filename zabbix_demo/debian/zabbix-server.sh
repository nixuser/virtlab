#!/bin/bash

wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian12_all.deb
dpkg -i zabbix-release_6.4-1+debian12_all.deb
apt update
# uncomment /etc/locale.gen
sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
# locale -a
locale-gen
#locale-gen es_US.UTF-8
#update-locale

apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# install database
apt-get -y install mariadb-server mariadb-client
systemctl enable --now mariadb.service

mysql -uroot <<EOF
DROP DATABASE IF EXISTS zabbix;
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by 'password';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
EOF

zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix --password=password zabbix

mysql -uroot <<EOF
set global log_bin_trust_function_creators = 0;
quit;
EOF

sed -i -e 's/# DBHost=localhost/DBHost=localhost/' /etc/zabbix/zabbix_server.conf
sed -i -e 's/# DBPassword=/DBPassword=password/' /etc/zabbix/zabbix_server.conf

# httpd config
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
