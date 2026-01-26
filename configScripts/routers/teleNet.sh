en
conf t
hostname teleRouter
ip domain name tele.net

ipv6 unicast-routing

int g6/0
ip address dhcp
ip nat outside
ipv6 address autoconfig
no shutdown
exit

int g1/0
ip address 9.6.11.1 255.255.255.224
ipv6 address 2001:db8:a::1/64
ipv6 address fe80::1 link-local
ip nat inside
no sh
exit

access-list 1 permit any
ip nat inside source list 1 int g6/0 overload
ip nat inside source static tcp 10.0.0.250 10050 192.168.1.153 10050
ip nat inside source static tcp 10.0.0.250 10051 192.168.1.153 10051
ip nat inside source static tcp 10.0.0.250 80 192.168.1.153 10049
ip nat inside source static tcp 10.0.0.250 443 192.168.1.153 10048
ip nat inside source static tcp 10.1.0.253 80 192.168.1.153 8080

ip route 0.0.0.0 0.0.0.0 192.168.1.1
router ospf 1
network 9.6.11.0 0.0.0.31 area 0
default-information originate   
exit

ip nat pool NAT64_POOL 192.168.1.153 192.168.1.153 prefix-length 24
ipv6 access-list NAT64_ACL
permit ipv6 ::/0 any
exit

ipv6 nat v6v4 source list NAT64_ACL pool NAT64_POOL overload

ipv6 router ospf 1
exit
int g1/0
ipv6 ospf 1 area 0
exit

#DNS config
ip name-server 1.1.1.1
ip dns server
ip dns view default
 dns forwarding
exit

# #PPPoE
# #Local user accounts
# aaa new-model
# service password-encryption
# username iroda@evil.inc password EvilIroda888
# username kavezo@evil.inc password EvilKavezo888
# username raktar@evil.inc password EvilRaktar888

# #IP pool for PPPoE clients
# ip local pool CustomersPool 9.6.11.2 9.6.11.30
# ipv6 local pool CustomersPoolv6_PD
# 2001:db8:a::/48 64
# ipv6 dhcp pool CustomersPoolv6_DHCP
#   prefix-delegation pool CustomersPoolv6_PD

# #BBA group
# bba-group pppoe PPPoEvils
#  virtual-template 1
# exit

# #Virtual Template 1
# interface virtual-template 1
#  mtu 1492
#  ipv6 enable
#  ipv6 nd managed-config-flag
#  ipv6 nd other-config-flag
#  no ipv6 nd ra suppress
#  ipv6 nd ra-interval 30
#  ipv6 nd ra lifetime 1800

#  ip unnumbered G1/0
#  peer default ip address pool CustomersPool
#  ppp ipcp dns 9.6.11.1 1.1.1.1
#  ipv6 dhcp server CUSTOMER1_IPV6_POOL

#  ppp authentication chap
#  no shutdown
# exit

# #Enable PPPoE on LAN interface
# interface g1/0
#  pppoe enable group PPPoEvils
#  no shutdown
# exit

end
