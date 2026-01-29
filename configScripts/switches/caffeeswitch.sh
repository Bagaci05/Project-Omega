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
exit

int range g0/1-3
switchport mode access
switchport access vlan 20
exit

int range g2/0-2
switchport mode access
switchport access vlan 10
exit

int g3/3
switchport mode access
switchport access vlan 30
exit
