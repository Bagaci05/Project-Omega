en
conf t
hostname R-K2
no ip domain-lookup
ip domain-name evil-inc.com
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"
snmp-server community public RO
snmp-server location SzerverSzoba
snmp-server enable traps

line vty 0 15
transport input ssh
login local
exit

line con 0
logging synchronous
exit


int g6/0
ip address 9.6.11.21 255.255.255.224
no sh
exit

int g0/0
ip address 172.16.0.2 255.255.255.248
standby 1 ip 172.16.0.6
standby 1 priority 110
standby 1 preempt
no sh

router ospf 1
network 9.6.11.0 0.0.0.31 area 0
network 172.16.0.0 0.0.0.7 area 1
exit

end
