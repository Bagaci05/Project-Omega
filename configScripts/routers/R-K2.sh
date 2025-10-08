en
conf t
hostname R-K2

int g6/0
ip address 9.6.11.21 255.255.255.224
no sh
exit

int g0/0
ip addreess 172.16.0.2 255.255.255.248
standby 1 172.16.0.6
standby 1 priority 110
standby 1 preempt
no sh

router ospf 1
network 9.6.11.0 0.0.0.31 area 0