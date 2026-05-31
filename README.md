<div align="center">

# 🛡️ Foundations of Cybersecurity — Portfolio

**A 12-week hands-on cybersecurity program covering Linux, networking, Python, cloud infrastructure, offensive security, and digital forensics.**

![Linux](https://img.shields.io/badge/Linux-Ubuntu-orange?logo=ubuntu&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![Nmap](https://img.shields.io/badge/Nmap-Network%20Scanning-brightgreen)
![Wireshark](https://img.shields.io/badge/Wireshark-Protocol%20Analysis-1679A7?logo=wireshark&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active%20Directory-Windows%20Server-0078D4?logo=windows&logoColor=white)

</div>

---

## 📋 Table of Contents

- [About](#about)
- [Skills Demonstrated](#skills-demonstrated)
- [Weekly Modules](#weekly-modules)
- [Repository Structure](#repository-structure)

---

## About

This repository contains all lab artifacts, scripts, reports, and architecture documents produced across a 12-week cybersecurity foundations program. Each week builds on the last — from Linux fundamentals and network analysis through exploitation, forensics, and incident response.

Every artifact was built hands-on in a live lab environment and committed directly from the command line.

---

## Skills Demonstrated

| Domain | Tools & Technologies |
|---|---|
| **Operating Systems** | Ubuntu Linux, Windows Server 2022, Server Core |
| **Scripting & Automation** | Python 3, Bash, PowerShell |
| **Networking** | TCP/IP, DNS, Wireshark, Nmap, Suricata, UFW |
| **Virtualization & Containers** | VirtualBox, UTM, Docker, Docker Compose |
| **Identity & Access** | Active Directory, Group Policy, SSSD, Kerberos |
| **Offensive Security** | Metasploit, SQL Injection, XSS, Reconnaissance |
| **Digital Forensics** | Volatility, Autopsy, chain-of-custody documentation |
| **Incident Response** | Attack timelines, SIEM alerting, escalation procedures |

---

## Weekly Modules

### Week 1 — Linux Fundamentals
> Sessions 1–3 · Filesystem navigation, file permission hardening, stream editing & log parsing

| Artifact | Description |
|---|---|
| `discovery.txt` | S01: Filesystem navigation & enumeration |
| `harden.sh` | S02: File permission hardening & security automation |
| `setup_verify.txt` | Environment setup verification |
| `notes.md` | Session notes covering all Week 1 concepts |

---

### Week 2 — Networking & Protocol Analysis
> Sessions 4–6 · OSI model, IP subnetting, DNS & protocol interrogation

| Artifact | Description |
|---|---|
| `network_audit.txt` | S04: Network audit results |
| `subnet_blueprint.txt` | S05: CIDR subnetting scheme |
| `protocol_audit.txt` | S06: DNS & protocol interrogation |
| `notes.md` | Session notes covering all Week 2 concepts |

---

### Week 3 — Python for Security
> Sessions 7–9 · Network scanning, log analysis, brute-force detection, process auditing

| Artifact | Description |
|---|---|
| `port_check.py` | S07: TCP port scanner |
| `brute_detector.py` | S08: Authentication log brute-force detector |
| `system_auditor.py` | S09: Process auditor with JSON alert output |
| `security_alert.json` | S09: Structured JSON security alert |
| `incident_response.py` | TLAB-03: Automated incident response pipeline |
| `threat_report.json` | TLAB-03: JSON threat report with attacker IPs |
| `notes.md` | Session notes covering all Week 3 concepts |

---

### Week 4 — Virtualization, Containers & Docker
> Sessions 10–12 · VM isolation, Docker operations, Docker Compose network segmentation

| Artifact | Description |
|---|---|
| `sandbox_report.txt` | S10: VM air-gap sandbox verification report |
| `deploy_web.sh` | S11: Disposable Nginx web server deployment script |
| `docker-compose.yml` | S12 / TLAB-04: Air-gapped multi-container stack |
| `notes.md` | Session notes covering all Week 4 concepts |

---

### Week 5 — Identity, Access & Active Directory
> Sessions 13–15 · Domain controller setup, PowerShell user provisioning, Group Policy, Linux-AD integration

| Artifact | Description |
|---|---|
| `onboard_engineers.ps1` | S13: PowerShell AD user provisioning script |
| `gpo_audit.txt` | S14: Group Policy audit & LSDOU inheritance report |
| `unified_identity.png` | S15: Screenshot proving Windows domain admin → Linux root |
| `notes.md` | Session notes covering all Week 5 concepts |

> ⚠️ Week 5 lab artifacts reside on the Windows Server VM and will be pushed in a future commit.

---

### Week 6 — Midterm Capstone
> Sessions 16–18 · OSI troubleshooting, forensic exam, solo enterprise deployment

| Artifact | Description |
|---|---|
| `readiness_check.log` | S16: OSI troubleshooting self-assessment |
| `practical_exam_report.txt` | S17: Forensic exam — file hunt, extraction & lockdown |
| `HardenedOutpost_SAD.pdf` | S18: Capstone Security Architecture Document (SAD) |
| `notes.md` | Session notes covering all Week 6 concepts |

---

### Week 7 — Reconnaissance & Vulnerability Analysis
> Sessions 19–21 · Passive OSINT, active Nmap scanning, CVE research & CVSS triage

| Artifact | Description |
|---|---|
| `ThreatProfile_CloudNano.md` | S19: Passive recon & OSINT threat profile |
| `nmap_scan_results.txt` | S20: Active reconnaissance Nmap scan results |
| `remediation_plan.md` | S21: CVE research & remediation plan |
| `Perimeter_Assessment.md` | Perimeter security assessment |
| `notes.md` | Session notes covering all Week 7 concepts |

---

### Weeks 8–9 — Exploitation & Post-Exploitation
> Sessions 22–27 · Metasploit, web application attacks, SQL injection, XSS, pivoting

| Artifact | Description |
|---|---|
| `sqli_report.txt` | S24: SQL injection findings report |
| `xss_payloads.txt` | S24: XSS session cookie theft payloads |
| `OmniPortal_Assessment.md` | Web application security assessment |
| `Deep_Pivot_Report.md` | Post-exploitation pivot report |
| `pivot_success.png` | Screenshot: successful pivot proof |
| `backup_discovery.txt` | Backup discovery findings |
| `notes.md` | Session notes covering all Weeks 8–9 concepts |

---

### Week 10 — Digital Forensics & Incident Response (DFIR)
> Sessions 28–30 · Live triage, disk forensics, memory forensics, chain of custody

| Artifact | Description |
|---|---|
| `attack_timeline.csv` | S28: Forensic attack timeline reconstruction |
| `apache_logs` | Apache log evidence file |
| `collection_log.txt` | Evidence collection chain-of-custody log |
| `forensic_findings.md` | S29: Disk forensics findings |
| `forensic_report.pdf` | Full forensic analysis report |
| `notes.md` | Session notes covering all Week 10 concepts |

---

### Week 11 — Active Defense
> Sessions 31–33 · Firewall hardening, intrusion detection (Suricata), endpoint detection & response

| Artifact | Description |
|---|---|
| `firewall_config.sh` | S31: UFW firewall rules & traffic filtering script |
| `custom_ids.rules` | S32: Custom Suricata intrusion detection rules |
| `edr_policy.xml` | S33: EDR policy configuration |
| `threat_ips.txt` | Threat IP blocklist |
| `notes.md` | Session notes covering all Week 11 concepts |

---

### Week 12 — The Final Reckoning
> Sessions 34–36 · Threat assessment, purple team operations, incident response

| Artifact | Description |
|---|---|
| `Incident_Response_Report.md` | Full incident response report |
| `Operation_Fortress_Report.md` | Purple team operation report |
| `final_threat_report.txt` | Final threat assessment |
| `escalation_path.txt` | Incident escalation path documentation |
| `tepp_postmortem.md` | Post-mortem analysis |
| `notes.md` | Session notes covering all Week 12 concepts |

---

## Repository Structure

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

*Built session by session. Committed line by line.*

</div>
