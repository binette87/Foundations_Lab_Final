import os

output = os.popen("df -h").read()

with open("/var/log/sys_audit.log", "w") as log:
    log.write(output)

print("[+] Audit complete. Results written to /var/log/sys_audit.log")
