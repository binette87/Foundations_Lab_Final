<div align="center">

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=28&pause=1000&color=00D4FF&center=true&vCenter=true&width=700&lines=Foundations+of+Cybersecurity;12-Week+Hands-On+Portfolio;Linux+%7C+Python+%7C+Docker+%7C+Forensics" alt="Typing SVG" />

<br/>

**A 12-week hands-on cybersecurity program covering Linux, networking, Python, cloud infrastructure, offensive security, and digital forensics.**

<br/>

![Linux](https://img.shields.io/badge/Linux-Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.x-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![Wireshark](https://img.shields.io/badge/Wireshark-Protocol%20Analysis-1679A7?style=for-the-badge&logo=wireshark&logoColor=white)
![Nmap](https://img.shields.io/badge/Nmap-Reconnaissance-00D4FF?style=for-the-badge)
![Active Directory](https://img.shields.io/badge/Active%20Directory-Windows%20Server-0078D4?style=for-the-badge&logo=windows&logoColor=white)

<br/>

![Weeks](https://img.shields.io/badge/Duration-12%20Weeks-blueviolet?style=flat-square)
![Sessions](https://img.shields.io/badge/Sessions-36-success?style=flat-square)
![Artifacts](https://img.shields.io/badge/Artifacts-Committed%20Weekly-orange?style=flat-square)

</div>

---

## 📋 Table of Contents

- [About](#about)
- [Skills Demonstrated](#skills-demonstrated)
- [Weekly Modules](#weekly-modules)
- [Repository Structure](#repository-structure)

---

## 🔎 About

This repository contains all lab artifacts, scripts, reports, and architecture documents produced across a 12-week cybersecurity foundations program. Each week builds on the last — from Linux fundamentals and network analysis through exploitation, forensics, and incident response.

Every artifact was built hands-on in a live lab environment and committed directly from the command line.

---

## ⚙️ Skills Demonstrated

| Domain | Tools & Technologies |
|---|---|
| 🐧 **Operating Systems** | Ubuntu Linux, Windows Server 2022, Server Core |
| 🐍 **Scripting & Automation** | Python 3, Bash, PowerShell |
| 🌐 **Networking** | TCP/IP, DNS, Wireshark, Nmap, Suricata, UFW |
| 🐳 **Virtualization & Containers** | VirtualBox, UTM, Docker, Docker Compose |
| 🔐 **Identity & Access** | Active Directory, Group Policy, SSSD, Kerberos |
| ⚔️ **Offensive Security** | Metasploit, SQL Injection, XSS, Reconnaissance |
| 🔬 **Digital Forensics** | Volatility, Autopsy, chain-of-custody documentation |
| 🚨 **Incident Response** | Attack timelines, SIEM alerting, escalation procedures |

---

## 📁 Weekly Modules

<details>
<summary><b>🟢 Week 1 — Linux Fundamentals</b> &nbsp;|&nbsp; Sessions 1–3 &nbsp;·&nbsp; Filesystem navigation, permission hardening, stream editing</summary>
<br/>

| Artifact | Description |
|---|---|
| `discovery.txt` | S01: Filesystem navigation & enumeration |
| `harden.sh` | S02: File permission hardening & security automation |
| `setup_verify.txt` | Environment setup verification |
| `notes.md` | Session notes covering all Week 1 concepts |

</details>

---

<details>
<summary><b>🟢 Week 2 — Networking & Protocol Analysis</b> &nbsp;|&nbsp; Sessions 4–6 &nbsp;·&nbsp; OSI model, IP subnetting, DNS & protocol interrogation</summary>
<br/>

| Artifact | Description |
|---|---|
| `network_audit.txt` | S04: Network audit results |
| `subnet_blueprint.txt` | S05: CIDR subnetting scheme |
| `protocol_audit.txt` | S06: DNS & protocol interrogation |
| `notes.md` | Session notes covering all Week 2 concepts |

</details>

---

<details>
<summary><b>🟢 Week 3 — Python for Security</b> &nbsp;|&nbsp; Sessions 7–9 &nbsp;·&nbsp; Network scanning, log analysis, brute-force detection, process auditing</summary>
<br/>

| Artifact | Description |
|---|---|
| `port_check.py` | S07: TCP port scanner |
| `brute_detector.py` | S08: Authentication log brute-force detector |
| `system_auditor.py` | S09: Process auditor with JSON alert output |
| `security_alert.json` | S09: Structured JSON security alert |
| `incident_response.py` | TLAB-03: Automated incident response pipeline |
| `threat_report.json` | TLAB-03: JSON threat report with attacker IPs |
| `notes.md` | Session notes covering all Week 3 concepts |

</details>

---

<details>
<summary><b>🟢 Week 4 — Virtualization, Containers & Docker</b> &nbsp;|&nbsp; Sessions 10–12 &nbsp;·&nbsp; VM isolation, Docker operations, Compose network segmentation</summary>
<br/>

| Artifact | Description |
|---|---|
| `sandbox_report.txt` | S10: VM air-gap sandbox verification report |
| `deploy_web.sh` | S11: Disposable Nginx web server deployment script |
| `docker-compose.yml` | S12 / TLAB-04: Air-gapped multi-container stack |
| `notes.md` | Session notes covering all Week 4 concepts |

</details>

---

<details>
<summary><b>🟡 Week 5 — Identity, Access & Active Directory</b> &nbsp;|&nbsp; Sessions 13–15 &nbsp;·&nbsp; Domain controller, PowerShell provisioning, Group Policy, Linux-AD integration</summary>
<br/>

| Artifact | Description |
|---|---|
| `onboard_engineers.ps1` | S13: PowerShell AD user provisioning script |
| `gpo_audit.txt` | S14: Group Policy audit & LSDOU inheritance report |
| `unified_identity.png` | S15: Screenshot proving Windows domain admin → Linux root |
| `notes.md` | Session notes covering all Week 5 concepts |

> ⚠️ Lab artifacts reside on the Windows Server VM and will be pushed in a future commit.

</details>

---

<details>
<summary><b>🟢 Week 6 — Midterm Capstone</b> &nbsp;|&nbsp; Sessions 16–18 &nbsp;·&nbsp; OSI troubleshooting, forensic exam, solo enterprise deployment</summary>
<br/>

| Artifact | Description |
|---|---|
| `readiness_check.log` | S16: OSI troubleshooting self-assessment |
| `practical_exam_report.txt` | S17: Forensic exam — file hunt, extraction & lockdown |
| `HardenedOutpost_SAD.pdf` | S18: Capstone Security Architecture Document (SAD) |
| `notes.md` | Session notes covering all Week 6 concepts |

</details>

---

<details>
<summary><b>🟢 Week 7 — Reconnaissance & Vulnerability Analysis</b> &nbsp;|&nbsp; Sessions 19–21 &nbsp;·&nbsp; Passive OSINT, active Nmap scanning, CVE research & CVSS triage</summary>
<br/>

| Artifact | Description |
|---|---|
| `ThreatProfile_CloudNano.md` | S19: Passive recon & OSINT threat profile |
| `nmap_scan_results.txt` | S20: Active reconnaissance Nmap scan results |
| `remediation_plan.md` | S21: CVE research & remediation plan |
| `Perimeter_Assessment.md` | Perimeter security assessment |
| `notes.md` | Session notes covering all Week 7 concepts |

</details>

---

<details>
<summary><b>🟢 Weeks 8–9 — Exploitation & Post-Exploitation</b> &nbsp;|&nbsp; Sessions 22–27 &nbsp;·&nbsp; Metasploit, web app attacks, SQL injection, XSS, pivoting</summary>
<br/>

| Artifact | Description |
|---|---|
| `sqli_report.txt` | S24: SQL injection findings report |
| `xss_payloads.txt` | S24: XSS session cookie theft payloads |
| `OmniPortal_Assessment.md` | Web application security assessment |
| `Deep_Pivot_Report.md` | Post-exploitation pivot report |
| `pivot_success.png` | Screenshot: successful pivot proof |
| `backup_discovery.txt` | Backup discovery findings |
| `notes.md` | Session notes covering all Weeks 8–9 concepts |

</details>

---

<details>
<summary><b>🟢 Week 10 — Digital Forensics & Incident Response (DFIR)</b> &nbsp;|&nbsp; Sessions 28–30 &nbsp;·&nbsp; Live triage, disk & memory forensics, chain of custody</summary>
<br/>

| Artifact | Description |
|---|---|
| `attack_timeline.csv` | S28: Forensic attack timeline reconstruction |
| `apache_logs` | Apache log evidence file |
| `collection_log.txt` | Evidence collection chain-of-custody log |
| `forensic_findings.md` | S29: Disk forensics findings |
| `forensic_report.pdf` | Full forensic analysis report |
| `notes.md` | Session notes covering all Week 10 concepts |

</details>

---

<details>
<summary><b>🟢 Week 11 — Active Defense</b> &nbsp;|&nbsp; Sessions 31–33 &nbsp;·&nbsp; Firewall hardening, intrusion detection (Suricata), EDR</summary>
<br/>

| Artifact | Description |
|---|---|
| `firewall_config.sh` | S31: UFW firewall rules & traffic filtering script |
| `custom_ids.rules` | S32: Custom Suricata intrusion detection rules |
| `edr_policy.xml` | S33: EDR policy configuration |
| `threat_ips.txt` | Threat IP blocklist |
| `notes.md` | Session notes covering all Week 11 concepts |

</details>

---

<details>
<summary><b>🟢 Week 12 — The Final Reckoning</b> &nbsp;|&nbsp; Sessions 34–36 &nbsp;·&nbsp; Threat assessment, purple team ops, incident response</summary>
<br/>

| Artifact | Description |
|---|---|
| `Incident_Response_Report.md` | Full incident response report |
| `Operation_Fortress_Report.md` | Purple team operation report |
| `final_threat_report.txt` | Final threat assessment |
| `escalation_path.txt` | Incident escalation path documentation |
| `tepp_postmortem.md` | Post-mortem analysis |
| `notes.md` | Session notes covering all Week 12 concepts |

</details>

---

## 🗂️ Repository Structure

```
Foundations_Lab_Final/
├── week-01_linux-fundamentals/
├── week-02_networking-protocol-analysis/
├── week-03_python-for-security/
├── week-04_docker-containers/
├── week-05_identity-access-active-directory/
├── week-06_midterm-capstone/
├── week-07_recon-vulnerability-analysis/
├── week-08-09_exploitation-post-exploitation/
├── week-10_dfir/
├── week-11_active-defense/
├── week-12_final-reckoning/
└── z_uncategorized/          ← files pending classification
```

---

<div align="center">

![Wave](https://capsule-render.vercel.app/api?type=waving&color=0:00D4FF,100:0078D4&height=100&section=footer)

*Built session by session. Committed line by line.*

</div>
