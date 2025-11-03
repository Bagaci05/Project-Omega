en
conf t
hostname R-K1
no ip domain-lookup
ip domain-name evil-inc.com
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"

line vty 0 15
transport input ssh
login local
exit

line con 0
logging synchronous
exit

int g1/0
ip address 172.16.0.1 255.255.255.248
no sh
exit

int g4/0
no sh
int g4/0.80
encapsulation dot1Q 80
ip address 10.0.0.1 255.255.255.128
ip helper-address 10.0.0.250
int g4/0.333
encapsulation dot1Q 333
ip address 10.0.0.193 255.255.255.224
ip helper-address 10.0.0.250
int g4/0.51
encapsulation dot1Q 51
ip address 10.0.0.129 255.255.255.192
ip helper-address 10.0.0.250
int g4/0.420
encapsulation dot1Q 420
ip address 10.0.0.249 255.255.255.248
int g4/0.666
encapsulation dot1Q 666
ip address 10.0.0.241 255.255.255.248
ip helper-address 10.0.0.250
int g4/0.444
encapsulation dot1Q 444
ip address 10.0.0.225 255.255.255.240
ip helper-address 10.0.0.250
exit

router ospf 1
network 172.16.0.0 0.0.0.7 area 1
network 10.0.0.0 0.0.0.127 area 1
network 10.0.0.128 0.0.0.63 area 1
network 10.0.0.192 0.0.0.31 area 1
network 10.0.0.224 0.0.0.15 area 1
network 10.0.0.240 0.0.0.7 area 1
network 10.0.0.248 0.0.0.7 area 1
exit

ip route 0.0.0.0 0.0.0.0 172.16.0.6
exit