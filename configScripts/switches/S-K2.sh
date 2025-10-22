en
conf t
hostname S-K2
no ip domain-lookup
ip domain-name evil-inc.com
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"

line vty 0 15
transport input ssh
login local
exit

vlan 51
vlan 80
vlan 333
vlan 369
vlan 420
vlan 444
vlan 666
vlan 888

exit

ip dhcp snooping
ip dhcp snooping vlan 51,80,333,420,444,666,888
ip arp inspection vlan 51,80,333,420,444,666,888

line con 0
logging synchronous
exit

int g0/0
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 51,80,333,420,444,666
switchport trunk native vlan 888
switchport nonegotiate
ip dhcp snooping trust
ip arp inspection trust
exit

int g0/1
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 420
switchport trunk native vlan 888
switchport nonegotiate
ip dhcp snooping trust
ip arp inspection trust
exit

int g0/2
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 666,444
switchport trunk native vlan 888
switchport nonegotiate
ip dhcp snooping trust
ip arp inspection trust
exit

int range g1/0-3
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 80,333
switchport trunk native vlan 888
switchport nonegotiate
ip dhcp snooping trust
ip arp inspection trust
channel-group 1 mode desirable
exit

int range g2/0-3
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 51
switchport trunk native vlan 888
switchport nonegotiate
ip dhcp snooping trust
ip arp inspection trust
channel-group 2 mode desirable
exit

int range g0/3,g3/0-3
sh
switchport mode access
switchport access vlan 369
exit