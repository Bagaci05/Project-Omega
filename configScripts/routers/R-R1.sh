en
conf t
hostname R-R1
no ip domain-lookup
ip domain-name evil-inc.com
ip ssh version 2
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"
crypto key generate rsa
1024

ipv6 unicast-routing

line vty 0 15
transport input ssh
login local
exit

line con 0
logging synchronous
#password C0N3MA50N
#login
exit

#enable secret 5@T@N666
#service password-encryption

int g0/0
ip address 9.6.11.30 255.255.255.224
ipv6 address 2001:db8:a::4/64
no sh

int g1/0
ip address 10.2.0.1 255.255.255.128
ipv6 address 2001:db8:3000:1::1/64
ipv6 address fe80::1 link-local
ipv6 enable
no sh

int g2/0
ip address 10.2.0.129 255.255.255.248
ipv6 address 2001:db8:3000:2::1/64
ipv6 address fe80::1 link-local
ipv6 enable
no sh
exit

router ospf 1
network 9.6.11.0 0.0.0.31 area 0
network 10.2.0.0 0.0.0.127 area 3
network 10.2.0.128 0.0.0.7 are 3
exit

ipv6 router ospf 1
exit
int g0/0
ipv6 ospf 1 area 0
int g1/0
ipv6 ospf 1 area 3
int g2/0
ipv6 ospf 1 area 3
exit