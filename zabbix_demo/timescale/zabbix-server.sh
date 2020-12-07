#!/bin/bash


wget https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.2-1+ubuntu18.04_all.deb
dpkg -i zabbix-release_5.2-1+ubuntu18.04_all.deb
apt  update
apt -y install zabbix-server-pgsql zabbix-frontend-php zabbix-nginx-conf zabbix-agent php7.2-pgsql

# install TimescaleDB
# `lsb_release -c -s` should return the correct codename of your OS
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -c -s)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
add-apt-repository ppa:timescale/timescaledb-ppa
apt -y install timescaledb-postgresql-12 -y
timescaledb-tune --quiet --yes 
echo "shared_preload_libraries = 'timescaledb'" >> /etc/postgresql/12/main/postgresql.conf
systemctl restart postgresql


sed -i -e 's/# DBHost=localhost/DBHost=localhost/' /etc/zabbix/zabbix_server.conf
sed -i -e 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf

# httpd config
sed -i -e "/listen/ s/#.*listen/listen/" /etc/zabbix/nginx.conf
sed -i -e "/server_name/ s/#.*server_name/server_name/" /etc/zabbix/nginx.conf
sed -i -e "/server_name/ s/example.com/localhost/" /etc/zabbix/nginx.conf
#

systemctl enable --now zabbix-server zabbix-agent nginx php7.2-fpm
