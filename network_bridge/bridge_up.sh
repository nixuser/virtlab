ip link add name br0 type bridge
ip link set eth1 master br0
ip link set eth2 master br0
ip link set eth3 master br0
ip link set dev br0 up
ip link set up dev eth1
ip link set up dev eth2
ip link set up dev eth3
ip link set up dev br0
