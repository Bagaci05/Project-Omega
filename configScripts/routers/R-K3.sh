en
conf t
hostname R-K3
no ip domain-lookup
ip domain-name evil-inc.com
ip ssh version 2
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"
crypto key generate rsa
1024
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
#password C0N3MA50N
#login
exit

#enable secret 5@T@N666
#service password-encryption


int g6/0
ip address 9.6.11.22 255.255.255.224
ipv6 address 2001:db8:a::3/64
no sh
exit

int g0/0
ip address 172.16.0.3 255.255.255.248
standby 1 ip 172.16.0.6
standby 1 priority 100
standby 1 preempt
ipv6 address 2001:db8:1000:15::3/64
standby version 2
standby 2 ipv6 autoconfig
standby 2 priority 100
no sh

router ospf 1
network 9.6.11.0 0.0.0.31 area 0
network 172.16.0.0 0.0.0.7 area 1
exit

ipv6 router ospf 1
exit
int g6/0
ipv6 ospf 1 area 0
int g0/0
ipv6 ospf 1 area 1

end
