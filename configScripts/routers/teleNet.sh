en
conf t
hostname teleRouter
ip domain name tele.net

ipv6 unicast-routing

line con 0
logging synchronous

#Ifconfig
int g6/0
 ip address dhcp
 ipv6 address autoconfig
 no shutdown
exit

#Pat v4
access-list 1 permit any
ip nat inside source list 1 int g6/0 overload

int g6/0
 ip nat outside
int g1/0
 ip nat inside
exit

#DG
ip route 0.0.0.0 0.0.0.0 192.168.1.1

#OSPF
router ospf 1
router-id 1.1.1.1
network 9.6.11.0 0.0.0.3 area 0
network 9.6.11.4 0.0.0.3 area 0
network 9.6.11.8 0.0.0.3 area 0
network 9.6.11.12 0.0.0.3 area 0
default-information originate   
exit

#Natv6v4
no ipv6 cef

int loopback 64
 ip address 172.16.1.1 255.255.255.255
 ipv6 nat
exit

interface GigabitEthernet6/0
 no ip virtual-reassembly
 ipv6 nat
interface GigabitEthernet3/0
 no ip virtual-reassembly
interface FastEthernet0/0
  ipv6 nat
 no ip virtual-reassembly
interface GigabitEthernet1/0
  ipv6 nat
 no ip virtual-reassembly
int s2/0
 no ip virtual-reassembly
 ipv6 nat
int s2/1
 no ip virtual-reassembly
 ipv6 nat
int s2/2
 no ip virtual-reassembly
 ipv6 nat
interface Virtual-Template1
 no ip virtual-reassembly
 ipv6 nat
exit


ipv6 nat prefix 2001:db8:ffff::/96
ipv6 access-list NAT64_ACL
permit ipv6 any any
exit

ip nat pool NAT64_POOL 192.168.1.153 192.168.1.153 prefix-length 24
ipv6 nat v6v4 source list NAT64_ACL pool NAT64_POOL overload


#ipv6 nat v6v4 source 2001:DB8:FFFF::10.10.10.10 10.10.10.10

int g3/0
ip address 10.10.10.1 255.255.255.0
ipv6 nat
ip nat inside
exit


#OSPFv3
ipv6 router ospf 1
exit


#PPPoE
#Local user accounts
aaa new-model
service password-encryption
username iroda@evil.inc password 0 EvilIroda888
username kavezo@evil.inc password 0 EvilKavezo888
username raktar@evil.inc password 0 EvilRaktar888

ip local pool CustomerPool 9.6.11.13 9.6.11.14
ipv6 local pool CustomersPoolv6_PD 2001:db8:b::/48 56
ipv6 dhcp pool CustomersPoolv6_DHCP
prefix-delegation pool CustomersPoolv6_PD

bba-group pppoe PPPoEvils
virtual-template 1

interface Virtual-Template1
ip address 9.6.11.13 255.255.255.252
ip nat inside
mtu 1492
ipv6 enable
ipv6 nd managed-config-flag
ipv6 nd other-config-flag
no ipv6 nd ra suppress
ipv6 nd ra-interval 30
ipv6 nd ra lifetime 1800
ip ospf network point-to-point
ip ospf 1 area 0
ipv6 ospf 10 area 0

peer default ip address pool CustomerPool
ppp ipcp dns 9.6.11.13 1.1.1.1
ipv6 dhcp server CustomersPoolv6_DHCP
ppp authentication chap

no shutdown
exit



int s2/0
ip address 9.6.11.1 255.255.255.252
ipv6 address 2001:db8:a:1::1/64 
ipv6 ospf 10 area 0
ip nat inside
encapsulation ppp
ppp authentication chap
no sh

int s2/1
ip address 9.6.11.5 255.255.255.252
ipv6 address 2001:db8:a:2::1/64
ipv6 ospf 10 area 0
ip nat inside
encapsulation ppp
ppp authentication chap
no sh

int s2/2
ip address 9.6.11.9 255.255.255.252
ipv6 address 2001:db8:a:3::1/64
ipv6 ospf 10 area 0
ip nat inside
encapsulation ppp
ppp authentication chap
no sh

int g1/0
pppoe enable group PPPoEvils
no shutdown

# no debug ppp authentication
# no debug pppoe events
# no debug vpdn error

end
