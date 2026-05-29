# CLOUDNANO REMEDIATION PLAN
**Operator:** Binette87  ## TOP 5 CRITICAL FIXES
*(From the 20 raw findings, select the 5 that pose the greatest ACTUAL risk. Explain your reasoning.)*

1. **Remote Code Execution in Apache Struts (Internet Facing Web Server)**
   * **Justification:**This is the highest priority because it is internet-facing with a CVSS 9.8, meaning an attacker can achieve full system takeover
today without needing physical access.

2. **Unauthenticated AWS S3 Bucket (Contains Customer PII)**
   * **Justification:** A publicly accessible bucket leaking customer PII poses immediate legal, compliance, and reputational risk and requires zero 
technical skill to exploit.

3. **SQL Injection in Login Page (Customer Database Portal)**
   * **Justification:** This internet-facing portal provides a direct path to the customer database, making data theft or destruction highly likely with 
well-known attack techniques.

4. **Cross-Site Scripting (XSS) on Support Forum**
   * **Justification:** The public-facing support forum allows attackers to inject malicious scripts that steal session tokens and attack customers
who trust the platform.

5. **Outdated PHP Version 5.4 (Public Marketing Blog)**
   * **Justification:** Running end-of-life PHP 5.4 on a public server exposes the system to numerous known, unpatched CVEs that attackers can exploit
with publicly available tools.
