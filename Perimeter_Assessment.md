# TITANCORP: PERIMETER ASSESSMENT REPORT
**Operator:** Binette87 **Target Subnet:** 172.88.0.0/24

## PHASE 1: ACTIVE ENUMERATION (NMAP)
*(List the live IPs discovered and their running services/versions)*
* **Host 1 (172.88.0.10):** nginx 1.14.2 — Port 80 open (HTTP)
* **Host 2 (172.88.0.15):** No open ports detected — Cache/Database server
* **Host 3 (172.88.0.20):** Apache httpd 2.4.66 — Port 80 open (HTTP)

## PHASE 2: VULNERABILITY AUDIT (NIKTO)
*(Run Nikto against the TWO web servers discovered above. List one major finding for each.)*
* **Web Server 1 Finding:** 172.88.0.10 (nginx 1.14.2) — Missing X-Frame-Options header, server leaks inodes via ETags
* **Web Server 2 Finding:** 172.88.0.20 (Apache 2.4.66) — HTTP TRACE method is active, making the host vulnerable to Cross-Site Tracing (XST) attacks

## PHASE 3: RISK TRIAGE
*(Review your findings. Identify the SINGLE highest-risk vulnerability across the entire DMZ. Justify why it is the top priority using the Likelihood x Impact formula.)*

* **Top Priority Remediation:** HTTP TRACE Method Enabled on 172.88.0.20 (Apache 2.4.66)
* **Justification:** This is the highest risk because TRACE is actively enabled on a public-facing web server, giving attackers a known exploitation
path for Cross-Site Tracing attacks that can steal session credentials, with high likelihood of exploitation and high impact on user data confidentiality.
