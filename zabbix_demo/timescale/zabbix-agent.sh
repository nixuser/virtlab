#!/bin/bash

wget https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.2-1+ubuntu18.04_all.deb
dpkg -i zabbix-release_5.2-1+ubuntu18.04_all.deb
apt update
apt -y install zabbix-agent
systemctl enable --now zabbix-agent.service
