en
conf t
hostname S-K4
no ip domain-lookup
ip domain-name evil-inc.com
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"

line vty 0 15
transport input ssh
login local
exit

vlan 80
vlan 333
vlan 888
vlan 369
exit

line con 0
logging synchronous
exit

# ip dhcp snooping
# ip dhcp snooping vlan 80,333,888
# ip arp inspection vlan 80,333,888

int range g1/0-3
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 80,333,888
switchport trunk native vlan 888
switchport nonegotiate
channel-group 1 mode auto
# ip dhcp snooping trust
# ip arp inspection trust
exit

int g0/0
#ip verify source
switchport mode access
switchport access vlan 80
# switchport port-security
# switchport port-security maximum 2
# switchport port-security mac-address sticky
# switchport port-security aging time 10
# spanning-tree portfast
# spanning-tree bpduguard enable
exit

int g0/1
#ip verify source
switchport mode access
switchport access vlan 333
# switchport port-security
# switchport port-security maximum 2
# switchport port-security mac-address sticky
# switchport port-security aging time 10
# spanning-tree portfast
# spanning-tree bpduguard enable
exit

int range g0/2-3,g2/0-3,g3/0-3
sh
switchport mode access
switchport access vlan 369
exit