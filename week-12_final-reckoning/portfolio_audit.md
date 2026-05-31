# Phase 1 Portfolio Audit

**Fellow:** Bineta Fall
**Date:** May 31, 2026
**Repository:** https://github.com/binetazak/Foundations_Lab_Final
**Program:** TKH Innovation Fellowship 2026 | Phase 1 | Cybersecurity

---

## Audit Summary

Prior to this audit, the repository was well-structured and consistently maintained, with dedicated week folders, session artifacts, and detailed `notes.md` files present throughout. The primary gaps identified were Week 5 lab artifacts pending push from the Windows Server VM due to hardware constraints, a small number of misplaced files in the Week 1 and Week 8–9 folders, and the `hyperstack_audit.json` artifact from Week 4 sitting in the `z_uncategorized/` folder awaiting relocation. All `notes.md` files are present and complete in APA style across every week of completed coursework.

---

## Week-by-Week Audit

### Week 01 — Linux Fundamentals & Filesystem Navigation

| Check | Status |
|---|---|
| Folder present | ✅ `week-01_linux-fundamentals/` |
| Artifacts present | ✅ `discovery.txt`, `harden.sh`, `setup_verify.txt` |
| notes.md present | ✅ |

**Notes:** Two files are present that do not belong to Week 1 — `final_threat_report.txt` (belongs in Week 12) and `threat_ips.txt` (belongs in Week 11). These were misplaced during early repository setup and will be relocated in a future cleanup commit.

---

### Week 02 — Networking & Protocol Analysis

| Check | Status |
|---|---|
| Folder present | ✅ `week-02_networking-protocol-analysis/` |
| Artifacts present | ✅ `network_audit.txt`, `subnet_blueprint.txt`, `protocol_audit.txt`, `tlab_report.txt` |
| notes.md present | ✅ |

**Notes:** All core session and TLAB artifacts are present and correctly placed.

---

### Week 03 — Python Scripting for Security

| Check | Status |
|---|---|
| Folder present | ✅ `week-03_python-for-security/` |
| Artifacts present | ✅ `port_check.py`, `brute_detector.py`, `sys_auditor.py`, `system_auditor.py`, `security_alert.json`, `incident_response.py`, `threat_report.json` |
| notes.md present | ✅ |

**Notes:** All session and TLAB artifacts are present. `sys_auditor.py` and `system_auditor.py` are two distinct artifacts from Sessions 7 and 9 respectively.

---

### Week 04 — Virtualization & Containers

| Check | Status |
|---|---|
| Folder present | ✅ `week-04_docker-containers/` |
| Artifacts present | ⚠️ `deploy_web.sh`, `docker-compose.yml` present — `sandbox_report.txt` and `hyperstack_audit.json` pending |
| notes.md present | ✅ |

**Notes:** `sandbox_report.txt` was created on the Ubuntu VM but could not be located for transfer to the Mac. `hyperstack_audit.json` is currently in `z_uncategorized/` and will be moved to this folder in a future commit.

---

### Week 05 — Identity, Access & Active Directory

| Check | Status |
|---|---|
| Folder present | ✅ `week-05_identity-access-active-directory/` |
| Artifacts present | ⚠️ No lab artifacts — `onboard_engineers.ps1`, `gpo_audit.txt`, `unified_identity.png` pending |
| notes.md present | ✅ |

**Notes:** Week 5 labs required a Windows Server 2022 Domain Controller and an Ubuntu VM running simultaneously, which exceeded available RAM on the 8GB host machine. The labs were not completed due to this hardware constraint. All session notes are fully documented in `notes.md`, covering the complete lab methodology, commands, and concepts for Sessions 13, 14, and 15. Lab artifacts will be pushed once the VM constraint is resolved.

---

### Week 06 — Phase 1 Midterm

| Check | Status |
|---|---|
| Folder present | ✅ `week-06_midterm-capstone/` |
| Artifacts present | ✅ `readiness_check.log`, `practical_exam_report.txt`, `HardenedOutpost_SAD.pdf` |
| notes.md present | ✅ |

**Notes:** All session artifacts and the capstone Security Architecture Document are present. Covers S16 (OSI troubleshooting), S17 (forensic practical exam), and S18 (Hardened Outpost solo deployment capstone).

---

### Week 07 — Reconnaissance & Vulnerability Analysis

| Check | Status |
|---|---|
| Folder present | ✅ `week-07_recon-vulnerability-analysis/` |
| Artifacts present | ✅ `ThreatProfile_CloudNano.md`, `nmap_scan_results.txt`, `remediation_plan.md`, `Perimeter_Assessment.md` |
| notes.md present | ✅ |

**Notes:** All session and TLAB artifacts are present. Covers passive OSINT (S19), active Nmap scanning (S20), vulnerability triage (S21), and the Operation Shadow Map capstone (TLAB-07).

---

### Week 08 — Exploitation Frameworks

| Check | Status |
|---|---|
| Folder present | ✅ `week-08-09_exploitation-post-exploitation/` (combined with Week 9) |
| Artifacts present | ⚠️ `Deep_Pivot_Report.md`, `pivot_success.png` present — `exploit_verification.png` (S22) and `escalation_path.txt` (S23) pending |
| notes.md present | ✅ |

**Notes:** Weeks 8 and 9 are combined into a single folder covering the full exploitation arc (S22–S27, TLAB-08/09). `exploit_verification.png` and `escalation_path.txt` were created on the VM and will be pushed in a future commit.

---

### Week 09 — Web Application Security

| Check | Status |
|---|---|
| Folder present | ✅ Combined with Week 8 in `week-08-09_exploitation-post-exploitation/` |
| Artifacts present | ✅ `sqli_report.txt`, `xss_payloads.txt`, `api_audit.log`, `OmniPortal_Assessment.md` |
| notes.md present | ✅ Shared with Week 8 |

**Notes:** All web application security artifacts are present. Covers SQL injection (S25), XSS and CSRF (S26), API BOLA (S27), and the Operation Omni-Portal full-stack assessment capstone (TLAB-09).

---

### Week 10 — Digital Forensics & Incident Response

| Check | Status |
|---|---|
| Folder present | ✅ `week-10_dfir/` |
| Artifacts present | ✅ `collection_log.txt`, `forensic_findings.md`, `attack_timeline.csv`, `apache_logs`, `forensic_report.pdf` |
| notes.md present | ✅ |

**Notes:** All session and TLAB artifacts are present. Covers live triage and chain of custody (S28), disk and memory forensics (S29), SIEM log correlation with ELK (S30), and the Operation Phantom Pursuit incident response capstone (TLAB-10).

---

### Week 11 — Active Defense: Firewalls, IDS & EDR

| Check | Status |
|---|---|
| Folder present | ✅ `week-11_active-defense/` |
| Artifacts present | ✅ `firewall_config.sh`, `custom_ids.rules`, `edr_policy.xml` |
| notes.md present | ✅ |

**Notes:** All session artifacts are present. `Operation_Fortress_Report.md` (TLAB-11) is currently in `week-12_final-reckoning/` and should be relocated to this folder. Covers iptables/UFW firewall engineering (S31), Suricata IDS rule authoring (S32), Sysmon EDR policy deployment (S33), and the Operation Fortress defense-in-depth capstone (TLAB-11).

---

## Repository Standards Check

| Standard | Status |
|---|---|
| README.md present and complete | ✅ Rebuilt with badges, animated header, collapsible sections, and structure diagram |
| Repository visibility set to Public | ⚠️ To be confirmed in GitHub settings before submission |
| All week folders present (week-01 through week-11) | ✅ All present — Weeks 8 and 9 are intentionally combined |
| notes.md present in every week folder | ✅ All eleven weeks have complete, APA-style notes |
| week-12/ folder contains portfolio_audit.md | ✅ This document |

---

## Professional Reflection

This portfolio represents eleven weeks of hands-on security engineering built entirely in live lab environments — every artifact committed from the command line, every concept applied before it was summarized. The breadth of the work is significant: the same practitioner who wrote `harden.sh` in Week 1 was writing Suricata IDS signatures and Sysmon EDR policies in Week 11, with SQL injection, network pivoting, disk forensics, and Active Directory in between. The work that stands out most is the DFIR arc in Week 10 — particularly the SIEM log correlation exercise, where a breach was reconstructed across three independent log sources by chaining IP pivots — because it demonstrated that security operations is fundamentally an analytical discipline, not just a technical one. Going into Phase 2, the area most worth strengthening is the Active Directory and Windows identity stack from Week 5, which was thoroughly documented but not executed due to VM hardware constraints. Completing those labs on proper hardware would close the one meaningful gap in an otherwise complete portfolio.

---

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5

The Linux Documentation Project. (2024). *The Linux system administrator's guide*. https://tldp.org
