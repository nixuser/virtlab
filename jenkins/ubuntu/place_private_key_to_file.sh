# order of VMs start is important for first time
vagrant up agentnode
# it will create private key
awk '{print "                " $0}'  $(grep.exe IdentityFile config | grep agentnode  | cut -d ' ' -f 4) >> casc_configs/private_file.yaml
vagrant up server
