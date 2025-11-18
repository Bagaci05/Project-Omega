enable
conf t
hostname CafeeRouter
ip domain-name evil.cafe
ip ssh version 2
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"
crypto key generate rsa
1024
#enable secret Abcd1234

int g2/0
ip address 10.1.0.254  255.255.255.0
no sh
exit

int g1/0
ip address 9.6.11.12 255.255.255.224
no sh
exit

router ospf 1
network 10.1.0.0 0.0.0.255 area 2
network 9.6.11.0 0.0.0.31 area 0
exit