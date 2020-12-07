#!/bin/bash

wget https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.2-1+ubuntu18.04_all.deb
dpkg -i zabbix-release_5.2-1+ubuntu18.04_all.deb
apt  update

apt -y install zabbix-proxy-mysql zabbix-agent

# install database
apt-get -y install mariadb-server-10.1 mariadb-client-10.1
systemctl enable --now mariadb.service

mysql -uroot <<EOF
create database zabbix_proxy character set utf8 collate utf8_bin;
grant all privileges on zabbix_proxy.* to zabbix@localhost identified by 'zabbix';
quit
EOF

zcat /usr/share/doc/zabbix-proxy-mysql/schema.sql.gz | mysql -uzabbix -pzabbix zabbix_proxy
sed -i -e 's/# DBHost=localhost/DBHost=localhost/' /etc/zabbix/zabbix_proxy.conf
sed -i -e 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_proxy.conf

systemctl enable --now zabbix-proxy zabbix-agent
