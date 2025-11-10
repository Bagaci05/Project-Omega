en
conf t
hostname S-K3
no ip domain-lookup
ip domain-name evil-inc.com
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"
ip default-gateway 10.0.0.225
snmp-server community public RO
snmp-server location SzerverSzoba
snmp-server enable traps


line vty 0 15
transport input ssh
login local
exit

vlan 666
vlan 444
vlan 888
vlan 369
exit

line con 0
logging synchronous
exit

# ip dhcp snooping
# ip dhcp snooping vlan 444,666,888
# ip arp inspection vlan 444,666,888

int vlan 444
ip address 10.0.0.238
no sh

int g0/0
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 444,666,888
switchport trunk native vlan 888
switchport nonegotiate
# ip dhcp snooping trust
# ip arp inspection trust
exit

int g0/1
#ip verify source
switchport mode access
switchport access vlan 666
# switchport port-security
# switchport port-security maximum 2
# switchport port-security mac-address sticky
# switchport port-security aging time 10
# spanning-tree portfast
# spanning-tree bpduguard enable
exit

int g0/2
#ip verify source
switchport mode access
switchport access vlan 444
# switchport port-security
# switchport port-security maximum 2
# switchport port-security mac-address sticky
# switchport port-security aging time 10
# spanning-tree portfast
# spanning-tree bpduguard enable
exit

int range g0/3,g1/0-3,g2/0-3,g3/0-3
sh
switchport mode access
switchport access vlan 369
exit