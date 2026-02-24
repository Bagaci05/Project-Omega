en
conf t
hostname R-R1
no ip domain-lookup
ip domain-name evil-inc.com
ip ssh version 2
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"
#crypto key generate rsa
#1024

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

ipv6 router ospf 1
exit

aaa new-model

interface s3/0
ip address 9.6.11.10 255.255.255.252
ipv6 address 2001:db8:a:3::2/64 
ipv6 ospf 10 area 0
encapsulation ppp
ppp chap hostname raktar@evil.inc
ppp chap password 0 EvilRaktar888
no sh
exit

int g1/0
ip address 10.2.0.1 255.255.255.128
ipv6 address 2001:db8:3000:1::1/64
ipv6 address fe80::1 link-local
ipv6 enable
ipv6 ospf 10 area 3
no sh

int g2/0
ip address 10.2.0.129 255.255.255.248
ipv6 address 2001:db8:3000:2::1/64
ipv6 address fe80::1 link-local
ipv6 enable
ipv6 ospf 10 area 3
no sh
exit

router ospf 1
router-id 4.4.4.4
network 9.6.11.0 0.0.0.255 area 0
network 10.2.0.0 0.0.0.127 area 3
network 10.2.0.128 0.0.0.7 are 3
exit

ip access-list extended VPN-IPv4
 permit ip 10.2.0.0 0.0.0.255 10.0.0.0 0.0.0.255
exit

ipv6 access-list VPN-IPv6
 permit ipv6 2001:db8:3000::/48 2001:db8:1000::/48
exit

crypto isakmp policy 10
 encr aes 256
 hash sha256
 authentication pre-share
 group 19
 lifetime 86400
exit

crypto isakmp key CR1T1CALP3SS! address 172.16.0.1
crypto isakmp key CR1T1CALP3SS! address ipv6 2001:db8:1000:15::1/64

crypto ipsec transform-set VPN-TS esp-aes 256 esp-sha256-hmac
mode tunnel
exit

crypto map VPN-MAP 10 ipsec-isakmp
 set peer 172.16.0.1
 set transform-set VPN-TS
 set pfs group19
 match address VPN-IPv4
exit

crypto map ipv6 VPN6-MAP 20 ipsec-isakmp
 set peer 2001:db8:1000:15::1
 set transform-set VPN-TS
 set pfs group19
 match address VPN-IPv6
exit

interface s3/0
 crypto map VPN-MAP
 ipv6 crypto map VPN6-MAP
exit

ip route 10.0.0.0 255.255.255.0 172.16.0.1
ipv6 route 2001:db8:1000::/48 2001:db8:1000:15::1
end