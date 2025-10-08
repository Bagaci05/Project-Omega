en
conf t
hostname R-K1

int g1/0
ip address 172.16.0.1 255.255.255.248
exit

ip route 0.0.0.0 0.0.0.0 172.16.0.6