en
conf t
hostname R-R1
ip domain-lookup
ip name-server 10.10.10.10
ip domain-name evil-inc.com
ip ssh version 2
username admin secret 3v1lD3vil!
aaa new-model
aaa authentication login default local
banner motd "Unauthorized access will result in sacrificing you! :)"
#crypto key generate rsa
#1024

ipv6 unicast-routing

line vty 0 15
transport input ssh
login authentication default
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

#NAT examption
ip access-list extended NAT-STATIC
deny ip 10.0.0.0 0.255.255.255 10.0.0.0 0.255.255.255
deny ip 10.0.0.0 0.255.255.255 172.16.0.0 0.0.255.255
permit ip host 10.2.0.130 any
exit

ip access-list extended NAT-DYNAMIC
deny ip 10.0.0.0 0.255.255.255 10.0.0.0 0.255.255.255
deny ip 10.0.0.0 0.255.255.255 172.16.0.0 0.0.255.255
permit ip 10.2.0.0 0.0.0.255 any
exit

route-map RM-STATIC-NAT permit 10
match ip address NAT-STATIC
exit

route-map RM-DYNAMIC-NAT permit 10
 match ip address NAT-DYNAMIC
exit

ip nat inside source route-map RM-DYNAMIC-NAT pool RAKTAR-POOL
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
permit tcp host 10.10.10.10 eq 53 any

#OSPF
permit ospf any any

#ICMP
permit icmp any host 9.6.11.10 echo
permit icmp any host 9.6.11.10 echo-reply
permit icmp any host 9.6.11.10 time-exceeded
permit icmp any host 9.6.11.10 unreachable

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

ipv6 access-list OUTSIDE-IN-V6

permit tcp any any established

#VPN
permit udp any any eq 500
permit udp any any eq 4500
permit 50 host 2001:db8:1000:15::1 host 2001:db8:a:3::2

#WEB
permit tcp any host 2001:db8:3000:2::2 eq 80
permit tcp any host 2001:db8:3000:2::2 eq 443

#DNS
permit udp host 2001:db8:faaa::1 eq 53 any

#OSPFv3
permit 89 any any
 
permit icmp any any echo-request
permit icmp any any echo-reply
permit icmp any any nd-na
permit icmp any any nd-ns
permit icmp any any router-advertisement
permit icmp any any time-exceeded
permit icmp any any unreachable
permit udp any any range 33434 33534

#Implicit deny
deny ipv6 any any
exit

ipv6 access-list SERVER-ACCESS1-V6

#WEB
permit tcp any host 2001:db8:3000:2::2 eq 80
permit tcp any host 2001:db8:3000:2::2 eq 443

#SSH
permit tcp host 2001:db8:3000:2::3 host 2001:db8:3000:2::2 eq 22
deny tcp any host 2001:db8:3000:2::2 eq 22

permit ipv6 any any
exit

ipv6 access-list SERVER-ACCESS2-V6

#WEB
permit tcp any host 2001:db8:3000:1::2 eq 80
permit tcp any host 2001:db8:3000:1::2 eq 443

#SSH
permit tcp host 2001:db8:3000:1::3 host 2001:db8:3000:1::2 eq 22
deny tcp any host 2001:db8:3000:1::2 eq 22

#DHCPv6
permit udp any host 2001:db8:3000:1::2 eq 546
permit udp any host 2001:db8:3000:1::2 eq 547

permit ipv6 any any
exit

#Interfaces

interface s3/0
ipv6 traffic-filter OUTSIDE-IN-V6 in
ipv6 tcp adjust-mss 1280
exit

interface g1/0
ipv6 traffic-filter SERVER-ACCESS2-V6 out
exit

interface g2/0
ipv6 traffic-filter SERVER-ACCESS1-V6 out
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
network 9.6.11.8 0.0.0.255 area 0
network 10.2.0.0 0.0.0.127 area 3
network 10.2.0.128 0.0.0.7 area 3
exit

ip access-list extended VPN-IPv4
permit ip 10.2.0.0 0.0.255.255 10.0.0.0 0.0.255.255
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

ip route 10.0.0.0 255.0.0.0 Serial3/0
ipv6 route 2001:db8:1000::/48 2001:db8:1000:15::1
ipv6 route ::/0 2001:DB8:A:3::1
end