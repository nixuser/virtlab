# automate steps from
# https://docs.opennebula.io/6.8/open_cluster_deployment/kvm_node/kvm_node_installation.html#kvm-node
# disable SELinux

# download and install mysql community repo rpm

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
yum -y makecache

yum -y install opennebula-node-kvm
systemctl restart libvirtd
