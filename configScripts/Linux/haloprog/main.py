#!/home/debian/haloprog/bin/python
from netmiko import ConnectHandler # pyright: ignore[reportMissingImports]
import re
import requests  # <--- NEW
import json      # <--- NEW
webhook_url = "https://discord.com/api/webhooks/1474349556711030835/g21tZs1FxuxVm4ePxder4fot60ipLnlXixBLTuiHR8kXo6BnOrzhhr_aGe4vuXwgNIpx"

device = {
    'device_type': 'cisco_ios',
    'host':   '10.0.0.249',
    'username': 'admin',
    'password': '3v1lD3vil!',
    'port': 22,
    'secret': '5@T@N666?',
}

def run_ping(testIp):
    try:
        print(f"Csatlakozás ide: {device['host']} ...")
        net_connect = ConnectHandler(**device)
        print("Ping küldése...")
        command = "ping " + testIp
        output = net_connect.send_command(command, read_timeout=35)
        
        print("\n--- Router Válasza ---")
        print(output)
        print("----------------------")

        match = re.search(r'Success rate is (\d+) percent', output)
        
        if match:
            percent = int(match.group(1))
            if percent == 100:
                dc_msg = f"✅ Success: Router success rate: {percent}%"
            elif percent > 0:
                dc_msg =f"⚠️ Warning: Packet Loss Router success rate: {percent}%"
            else:
                dc_msg = f"❗**Ping Failed!** Router success rate: {percent}%"
            print(dc_msg)
            try:
                requests.post(webhook_url, json={"content": dc_msg})
                print(">> Discord alert sent.")
            except Exception as e:
                print(f"Failed to send alert: {e}")

        net_connect.disconnect()

    except Exception as e:
        print(f"Hiba történt: {e}")

if __name__ == "__main__":
    run_ping("9.6.11.10")