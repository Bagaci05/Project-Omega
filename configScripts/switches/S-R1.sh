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

vlan 369

int range g0/1-2
switchport port-security
switchport port-security maximum 2
switchport port-security mac-address sticky
switchport port-security aging time 10
spanning-tree portfast
spanning-tree bpduguard enable
exit

int range g0/3,g1/0-3,g2/0-3,g3/0-3
sh
switchport mode access
switchport access vlan 369
exit