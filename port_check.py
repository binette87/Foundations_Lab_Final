import socket
targets = ["127.0.0.1", "8.8.8.8", "1.1.1.1", "10.0.0.1"]
for ip in targets:
    print(f"--- Checking Server: {ip} ---")
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(1)
    result = s.connect_ex((ip, 22))
    if result == 0:
        print(f"SUCCESS: Port 22 is OPEN on {ip}")
    else:
        print(f"FAILED: Port 22 is CLOSED on {ip}")
    s.close()
