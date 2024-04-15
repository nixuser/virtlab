#!/bin/bash

wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1+debian12_all.deb
dpkg -i zabbix-release_6.4-1+debian12_all.deb
apt update
# uncomment /etc/locale.gen
sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
# locale -a
locale-gen

apt -y install zabbix-agent
systemctl enable --now zabbix-agent.service
