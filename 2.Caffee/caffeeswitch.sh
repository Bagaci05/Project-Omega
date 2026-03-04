en
conf t

hostname CaffeeSwitch

vlan 10
name WinClient
vlan 20
name Admin
vlan 30
name Wlan
exit

int g0/0
switchport trun encapsulation dot1q
switchport mode trun
switchport trunk allowed vlan 10,20,30
ip dhcp snooping trust
exit

int range g0/1-3
switchport mode access
switchport access vlan 20
switchport port-security maximum 1
switchport port-security violation shutdown
switchport port-security mac-address sticky
spanning-tree portfast
spanning-tree bpduguard enable
exit

int range g2/0-2
switchport mode access
switchport access vlan 10
switchport port-security maximum 1
switchport port-security violation shutdown
switchport port-security mac-address sticky
spanning-tree portfast
spanning-tree bpduguard enable
exit

int g3/3
switchport mode access
switchport access vlan 30
switchport port-security maximum 1
switchport port-security violation shutdown
switchport port-security mac-address sticky
spanning-tree portfast
spanning-tree bpduguard enable
exit

int g0/2
ip dhcp snooping trust
exit