#!/usr/bin/env python3
import subprocess
import json
import os

print("[*] Initiating System Audit...")


# INSTRUCTION 1: Execute ps aux
process_list = subprocess.run(["ps", "aux"], capture_output=True, text=True)

# INSTRUCTION 2: Search for the malicious process
if "unauthorized_cryptominer" in process_list.stdout:
    # INSTRUCTION 3: Create the dictionary
    alert_data = {
        "event": "Unauthorized Process",
        "severity": "High",
        "process": "unauthorized_cryptominer"
    }
    
    # INSTRUCTION 4: Export to JSON (This MUST be indented inside the IF)
    print("[!] Threat detected! Generating security_alert.json...")
    with open("security_alert.json", "w") as file:
        json.dump(alert_data, file, indent=4)
else:
    print("[+] System Scan Clear: No threats detected.")

print("[+] Audit Complete.")
