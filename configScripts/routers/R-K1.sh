en
conf t
hostname R-K1

int g1/0
ip address 172.16.0.1 255.255.255.248
no sh
exit

int g3/0
ip address 10.0.10.1 255.255.255.248
no sh
exit

router ospf 1
network 172.16.0.0 0.0.0.7 area 1
network 10.0.10.0 0.0.0.7 area 1
exit

ip route 0.0.0.0 0.0.0.0 172.16.0.6
exit