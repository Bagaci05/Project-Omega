en
conf t
hostname S-K1
no ip domain-lookup
ip domain-name evil-inc.com
ip ssh version 2
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"
crypto key generate rsa
1024
ip default-gateway 10.0.0.249
snmp-server community public RO
snmp-server location SzerverSzoba
snmp-server enable traps


line vty 0 15
transport input ssh
login local
exit

vlan 369
name NONE
vlan 420
name Management
vlan 888
name Native
exit

ip dhcp snooping
ip dhcp snooping vlan 80,51,420,333,444,666

line con 0
logging synchronous
#password C0N3MA50N
#login
exit

#enable secret 5@T@N666
#service password-encryption

int vlan 420
ip address dhcp
no sh

int range g0/1-2
#ip verify source
switchport mode access
switchport access vlan 420
switchport port-security
switchport port-security maximum 2
switchport port-security mac-address sticky
switchport port-security aging time 10
spanning-tree portfast
spanning-tree bpduguard enable
exit

int g0/1
ip dhcp snooping trust

int g0/2
ip dhcp snooping limit rate 10

int g0/0
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 420,888
switchport trunk native vlan 888
switchport nonegotiate
ip dhcp snooping trust
exit

int range g0/3,g1/0-3,g2/0-3,g3/0-3
sh
switchport mode access
switchport access vlan 369
exit

#csak addig amíg nincs DHCP szerver
#ip arp inspection filter static-entry
#ip source binding 0c4f.66b3.0000 vlan 420 10.0.0.251 interface Gi0/2
