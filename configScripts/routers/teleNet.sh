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
ip nat inside source static tcp 10.0.0.250 10050 192.168.1.153 10050
ip nat inside source static tcp 10.0.0.250 10051 192.168.1.153 10051
ip nat inside source static tcp 10.0.0.250 80 192.168.1.153 10049
ip nat inside source static tcp 10.0.0.250 443 192.168.1.153 10048

ip route 0.0.0.0 0.0.0.0 192.168.1.1
router ospf 1
network 9.6.11.0 0.0.0.31 area 0
default-information originate   
exit

end