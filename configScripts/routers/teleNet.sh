en
conf t
hostname teleRouter
ip domain name tele.net

int g6/0
ip address dhcp
ip nat outside
no shutdown
exit

int g1/0
ip address 9.6.11.1 255.255.255.224
ip nat inside
no sh
exit

access-list 1 permit any
ip nat inside source list 1 int g6/0 overload

ip route 0.0.0.0 0.0.0.0 192.168.122.1
router ospf 1
network 9.6.11.0 0.0.0.31 area 0
default-information originate   
exit


end