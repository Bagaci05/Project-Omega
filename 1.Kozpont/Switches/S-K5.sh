en
conf t
hostname S-K5
no ip domain-lookup
ip domain-name evil-inc.com
ip ssh version 2
username admin secret 3v1lD3vil!
banner motd "Unauthorized access will result in sacrificing you! :)"
crypto key generate rsa
1024
ip default-gateway 10.0.0.129
snmp-server community public RO
snmp-server location SzerverSzoba
snmp-server enable traps


line vty 0 15
transport input ssh
login local
exit

vlan 51
name Experimental
vlan 888
name Native
vlan 369
name NONE
exit

line con 0
logging synchronous
#password C0N3MA50N
#login
exit

#enable secret 5@T@N666
#service password-encryption

int vlan 51
ip address dhcp
no sh

# ip dhcp snooping
# ip dhcp snooping vlan 51,888
# ip arp inspection vlan 51,888

int range g2/0-3
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan 51,888
switchport trunk native vlan 888
switchport nonegotiate
channel-group 2 mode auto
# ip dhcp snooping trust
# ip arp inspection trust
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