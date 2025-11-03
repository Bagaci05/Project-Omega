en
conf t
hostname S-K5
no ip domain-lookup
ip domain-name evil-inc.com
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"

line vty 0 15
transport input ssh
login local
exit

vlan 51
vlan 888
vlan 369
exit

ip dhcp snooping
ip dhcp snooping vlan 51,888
ip arp inspection vlan 51,888

line con 0
logging synchronous
exit

int range g2/0-3
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 51,888
switchport trunk native vlan 888
switchport nonegotiate
ip dhcp snooping trust
ip arp inspection trust
channel-group 2 mode auto
exit

int g0/0
#ip verify source
switchport mode access
switchport access vlan 51
switchport port-security
switchport port-security maximum 2
switchport port-security mac-address sticky
switchport port-security aging time 10
spanning-tree portfast
spanning-tree bpduguard enable
exit

int range g0/1-3,g1/0-3,g3/0-3
sh
switchport mode access
switchport access vlan 369
exit