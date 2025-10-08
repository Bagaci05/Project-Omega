en
conf t
hostname R-K3

int g6/0
ip address 9.6.11.22 255.255.255.224
no sh
exit

int g0/0
ip address 172.16.0.3 255.255.255.248
standby 1 172.16.0.6
standby 1 priority 100
standby 1 preempt
no sh

router ospf 1
network 9.6.11.0 0.0.0.31 area 0
network 172.16.0.0 0.0.0.7 area 1