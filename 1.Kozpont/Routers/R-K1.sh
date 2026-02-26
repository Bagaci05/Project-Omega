en
conf t
hostname R-K1
no ip domain-lookup
ip domain-name evil-inc.com
ip ssh version 2
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"
#crypto key generate rsa
#1024
snmp-server community public RO
snmp-server location SzerverSzoba
snmp-server enable traps

ipv6 unicast-routing

line vty 0 15
transport input ssh
login local
exit

line con 0
logging synchronous
#password C0N3MA50N%
#login
exit

#enable secret 5@T@N666?
#service password-encryption

ip nat inside source static 10.0.0.250 172.16.0.4 

int g1/0
ip address 172.16.0.1 255.255.255.248
ipv6 address 2001:db8:1000:15::1/64
ip nat outside
no sh
exit

int g4/0
no sh
int g4/0.80
encapsulation dot1Q 80
ip address 10.0.0.1 255.255.255.128
ip helper-address 10.0.0.250
ipv6 address 2001:db8:1000:80::1/64
ipv6 address fe80::1 link-local
ipv6 enable
ipv6 ospf 10 area 1
int g4/0.333
encapsulation dot1Q 333
ip address 10.0.0.193 255.255.255.224
ip helper-address 10.0.0.250
ipv6 address 2001:db8:1000:333::1/64
ipv6 address fe80::1 link-local
ipv6 enable
ipv6 ospf 10 area 1
int g4/0.51
encapsulation dot1Q 51
ip address 10.0.0.129 255.255.255.192
ip helper-address 10.0.0.250
ipv6 address 2001:db8:1000:51::1/64
ipv6 address fe80::1 link-local
ipv6 enable
ipv6 ospf 10 area 1
int g4/0.420
encapsulation dot1Q 420
ip address 10.0.0.249 255.255.255.248
ipv6 address 2001:db8:1000:420::1/64
ipv6 address fe80::1 link-local
ipv6 enable
ipv6 ospf 10 area 1
ip nat inside
int g4/0.666
encapsulation dot1Q 666
ip address 10.0.0.241 255.255.255.248
ip helper-address 10.0.0.250
ipv6 address 2001:db8:1000:666::1/64
ipv6 address fe80::1 link-local
ipv6 enable
ipv6 ospf 10 area 1
int g4/0.444
encapsulation dot1Q 444
ip address 10.0.0.225 255.255.255.240
ip helper-address 10.0.0.250
ipv6 address 2001:db8:1000:444::1/64
ipv6 address fe80::1 link-local
ipv6 enable
ipv6 ospf 10 area 1
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

ipv6 router ospf 10
exit
int g1/0
ipv6 ospf 10 area 0

ip route 0.0.0.0 0.0.0.0 172.16.0.6

ip access-list extended VPN-IPv4
 permit ip 10.0.0.0 0.0.0.255 10.2.0.0 0.0.0.255
exit

ipv6 access-list VPN-IPv6
 permit ipv6 2001:db8:1000::/48 2001:db8:3000::/48
exit

crypto isakmp policy 10
 encr aes 256
 hash sha256
 authentication pre-share
 group 19
 lifetime 86400
exit

crypto isakmp key CR1T1CALP3SS! address 9.6.11.10
crypto isakmp key CR1T1CALP3SS! address ipv6 2001:db8:a:3::2/64

crypto ipsec transform-set VPN-TS esp-aes 256 esp-sha256-hmac
mode tunnel
exit

crypto map VPN-MAP 10 ipsec-isakmp
 set peer 9.6.11.10
 set transform-set VPN-TS
 set pfs group19
 match address VPN-IPv4
exit

crypto map ipv6 VPN6-MAP 10 ipsec-isakmp
 set peer 2001:db8:a:3::2
 set transform-set VPN-TS
 set pfs group19
 match address VPN-IPv6
exit

interface G1/0
 crypto map VPN-MAP
 ipv6 crypto map VPN6-MAP
exit

ip route 10.2.0.0 255.255.255.0 9.6.11.10
ipv6 route 2001:db8:3000::/48 2001:db8:a:3::2

end
