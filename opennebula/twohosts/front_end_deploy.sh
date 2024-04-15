# automate steps from
# https://docs.opennebula.io/6.8/installation_and_configuration/frontend_installation/install.html#frontend-installation
# disable SELinux

# download and install mysql community repo rpm
yum install -y /vagrant/mysql80-community-release-el9-5.noarch.rpm
yum makecache

yum -y install epel-release

cat << "EOT" > /etc/yum.repos.d/opennebula.repo
[opennebula]
name=OpenNebula Community Edition
baseurl=https://downloads.opennebula.io/repo/6.8/AlmaLinux/$releasever/$basearch
enabled=1
gpgkey=https://downloads.opennebula.io/repo/repo2.key
gpgcheck=1
repo_gpgcheck=1
EOT
yum makecache

yum -y install opennebula opennebula-sunstone opennebula-fireedge opennebula-gate opennebula-flow opennebula-provision
