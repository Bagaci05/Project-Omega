en
conf t
hostname R-R1
ip domain-lookup
ip name-server 10.10.10.10
ip name-server 8.8.8.8
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

ip nat pool RAKTAR-POOL 100.100.100.1 100.100.100.29 netmask 255.255.255.224

ip access-list extended NAT-DYNAMIC
deny ip 10.2.0.0 0.0.0.255 10.0.0.0 0.0.0.255
deny ip host 10.2.0.130 any
permit ip 10.2.0.0 0.0.0.255 any
exit

#NAT examption
ip access-list extended NAT-STATIC
deny ip host 10.2.0.130 10.0.0.0 0.0.0.255
permit ip host 10.2.0.130 any
exit

route-map RM-STATIC-NAT permit 10
match ip address NAT-STATIC
exit

ip nat inside source list NAT-DYNAMIC pool RAKTAR-POOL
ip nat inside source static 10.2.0.130 100.100.100.30 route-map RM-STATIC-NAT

ip access-list extended OUTSIDE-IN

#Established
permit tcp any any established

#VPN engedélyezése
permit udp any any eq 500
permit udp any any eq 4500
permit esp host 172.16.0.1 host 9.6.11.10

#WEB
permit tcp any host 100.100.100.30 eq 80
permit tcp any host 100.100.100.30 eq 443

#DNS
permit udp host 10.10.10.10 eq 53 any
permit tcp host 10.10.10.10 eq 53 any established

#OSPF
permit ospf any any

#ICMP
permit icmp any host 9.6.11.10 echo
permit icmp any host 9.6.11.10 echo-reply

#Implicit deny
deny ip any any 
exit

ip access-list extended SERVER-ACCESS1

permit tcp any host 10.2.0.130 eq 80
permit tcp any host 10.2.0.130 eq 443

#ADMIN PC access
permit tcp host 10.2.0.131 host 10.2.0.130 eq 22
deny tcp any host 10.2.0.130 eq 22

#Enabling all other 
permit ip any any
exit

ip access-list extended SERVER-ACCESS2

permit tcp any host 10.2.0.2 eq 80
permit tcp any host 10.2.0.2 eq 443

#ADMIN PC access
permit tcp host 10.2.0.131 host 10.2.0.2 eq 22
deny tcp any host 10.2.0.2 eq 22

#DHCP
permit udp any host 10.2.0.2 eq 67
permit udp any host 10.2.0.2 eq 68

#Enabling all other 
permit ip any any
exit

#Interface
interface s3/0
ip access-group OUTSIDE-IN in
ip tcp adjust-mss 1360

int g1/0
ip access-group SERVER-ACCESS2 out

int g2/0
ip access-group SERVER-ACCESS1 out
exit

interface s3/0
ip address 9.6.11.10 255.255.255.252
ip nat outside
ipv6 address 2001:db8:a:3::2/64 
ipv6 ospf 10 area 0
encapsulation ppp
ppp chap hostname raktar@evil.inc
ppp chap password 0 EvilRaktar888
no sh
exit

int g1/0
ip address 10.2.0.1 255.255.255.128
ip nat inside
ipv6 address 2001:db8:3000:1::1/64
ipv6 address fe80::1 link-local
ipv6 enable
ipv6 ospf 10 area 3
no sh

int g2/0
ip address 10.2.0.129 255.255.255.248
ip nat inside
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