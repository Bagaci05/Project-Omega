#!/home/debian/haloprog/bin/python
from netmiko import ConnectHandler
import re

device = {
    'device_type': 'cisco_ios',
    'host':   '10.0.0.249',
    'username': 'admin',
    'password': '3v1lD3vil!',
    'port': 22,
    'secret': '5@T@N666?',
}

def run_ping():
    try:
        print(f"Csatlakozás ide: {device['host']} ...")
        net_connect = ConnectHandler(**device)
        
        # Ha kell enable mód (privilege exec), vedd ki a kommentet:
        # net_connect.enable()

        print("Ping küldése...")
        
        # Parancs futtatása
        # A Netmiko megvárja a kimenetet
        output = net_connect.send_command("ping 8.8.8.8", read_timeout=10)
        
        print("\n--- Router Válasza ---")
        print(output)
        print("----------------------")

        # Eredmény elemzése (Regex segítségével)
        # Keresi a "Success rate is X percent" részt
        match = re.search(r'Success rate is (\d+) percent', output)
        
        if match:
            percent = int(match.group(1))
            if percent == 100:
                print(">> SIKER: A Ping 100%-os volt.")
            elif percent > 0:
                print(f">> FIGYELEM: Csomagvesztés történt ({percent}% siker).")
            else:
                print(">> HIBA: A Ping sikertelen.")
        else:
            print(">> Nem sikerült értelmezni a kimenetet.")

        # Kapcsolat bontása
        net_connect.disconnect()

    except Exception as e:
        print(f"Hiba történt: {e}")

if __name__ == "__main__":
    run_ping()