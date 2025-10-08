enable
conf t
hostname CafeeRouter
ip domain-name evil.cafe
crypto key generate rsa
1024
enable secret Abcd1234

int g2/0
ip address 10.0.0.254  255.255.255.0
no sh
exit

int g1/0
ip address 9.6.11.12 255.255.255.224
no sh
exit

router ospf 1
netwrok 10.0.0.0 0.0.0.255 area 0
network 9.6.11.0 0.0.0.31 area 0
exit