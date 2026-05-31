# Phase 1 Portfolio Audit

**Fellow:** Bineta Fall  
**Date:** May 31, 2026  
**Repository:** https://github.com/binetazak/Foundations_Lab_Final  
**TKH Innovation Fellowship 2026 | Phase 1 | Cybersecurity**

---

## Audit Summary

Prior to this audit, the repository was well-structured and consistently maintained across all eleven weeks of completed coursework, with dedicated week folders, session artifacts, and detailed `notes.md` files present throughout. The primary gaps identified were: Week 5 lab artifacts pending push from the Windows Server VM due to architecture constraints, a small number of misplaced files in Week 1 and the Week 8–9 folder, and the `hyperstack_audit.json` artifact from Week 4 sitting in the `z_uncategorized/` folder awaiting assignment. All `notes.md` files are present and complete in APA style across every week.

---

## Week-by-Week Audit

### Week 01 — Linux Fundamentals & Filesystem Navigation

- **Folder present:** Yes — `week-01_linux-fundamentals/`
- **Artifacts present:** Yes — `discovery.txt`, `harden.sh`, `setup_verify.txt`
- **notes.md present:** Yes
- **Notes:** Two files are present that do not belong to Week 1 — `final_threat_report.txt` (belongs in Week 12) and `threat_ips.txt` (belongs in Week 11). These were likely misplaced during early repository setup and should be relocated in a future cleanup commit.

---

### Week 02 — Networking & Protocol Analysis

- **Folder present:** Yes — `week-02_networking-protocol-analysis/`
- **Artifacts present:** Yes — `network_audit.txt`, `subnet_blueprint.txt`, `protocol_audit.txt`, `tlab_report.txt`
- **notes.md present:** Yes
- **Notes:** All core session artifacts are present. `tlab_report.txt` is an additional TLAB artifact that is correctly placed.

---

### Week 03 — Python Scripting for Security

- **Folder present:** Yes — `week-03_python-for-security/`
- **Artifacts present:** Yes — `port_check.py`, `brute_detector.py`, `sys_auditor.py`, `system_auditor.py`, `security_alert.json`, `incident_response.py`, `threat_report.json`
- **notes.md present:** Yes
- **Notes:** All session and TLAB artifacts are present and correctly placed. Note: `sys_auditor.py` and `system_auditor.py` are two distinct artifacts from Sessions 7 and 9 respectively.

---

### Week 04 — Virtualization & Containers

- **Folder present:** Yes — `week-04_docker-containers/`
- **Artifacts present:** Partial — `deploy_web.sh`, `docker-compose.yml` present; `sandbox_report.txt` (S10) and `hyperstack_audit.json` (TLAB-04) are pending
- **notes.md present:** Yes
- **Notes:** `sandbox_report.txt` was created on the Ubuntu VM but could not be located for transfer to the Mac. `hyperstack_audit.json` is currently in `z_uncategorized/` and should be moved to this folder. Both artifacts will be pushed in a future commit once recovered from the VM.

---

### Week 05 — Identity, Access & Active Directory

- **Folder present:** Yes — `week-05_identity-access-active-directory/`
- **Artifacts present:** No — `onboard_engineers.ps1` (S13), `gpo_audit.txt` (S14), and `unified_identity.png` (S15) are all pending
- **notes.md present:** Yes
- **Notes:** Week 5 labs required a Windows Server 2022 Domain Controller and an Ubuntu VM running simultaneously, which exceeded available RAM on the 8GB host machine. The labs were not completed due to this architecture constraint. All session notes are fully documented in `notes.md`, including the complete lab methodology, commands, and concepts for S13, S14, and S15. Lab artifacts will be pushed once the VM constraint is resolved.

---

### Week 06 — Phase 1 Midterm

- **Folder present:** Yes — `week-06_midterm-capstone/`
- **Artifacts present:** Yes — `readiness_check.log`, `practical_exam_report.txt`, `HardenedOutpost_SAD.pdf`
- **notes.md present:** Yes
- **Notes:** All three session artifacts and the capstone SAD are present. The folder covers S16 (OSI troubleshooting), S17 (forensic practical exam), and S18 (Hardened Outpost solo deployment capstone).

---

### Week 07 — Reconnaissance & Vulnerability Analysis

- **Folder present:** Yes — `week-07_recon-vulnerability-analysis/`
- **Artifacts present:** Yes — `ThreatProfile_CloudNano.md`, `nmap_scan_results.txt`, `remediation_plan.md`, `Perimeter_Assessment.md`
- **notes.md present:** Yes
- **Notes:** All session and TLAB artifacts are present and correctly placed. Covers passive OSINT (S19), active Nmap scanning (S20), vulnerability triage (S21), and the Operation Shadow Map capstone (TLAB-07).

---

### Week 08 — Exploitation Frameworks

- **Folder present:** Yes — `week-08-09_exploitation-post-exploitation/` (combined with Week 9)
- **Artifacts present:** Yes — `Deep_Pivot_Report.md`, `pivot_success.png`, `sqli_report.txt`, `xss_payloads.txt`, `api_audit.log`, `OmniPortal_Assessment.md`, `backup_discovery.txt`; `exploit_verification.png` (S22) and `escalation_path.txt` (S23) are pending push from VM
- **notes.md present:** Yes
- **Notes:** Weeks 8 and 9 are combined into a single folder covering the full exploitation arc (S22–S27 and TLAB-08/09). `sandbox_report.txt` is present in this folder but is actually a Week 4 artifact misplaced here; it should be relocated. `exploit_verification.png` and `escalation_path.txt` were created on the VM and will be pushed in a future commit.

---

### Week 09 — Web Application Security

- **Folder present:** Yes — combined with Week 8 in `week-08-09_exploitation-post-exploitation/`
- **Artifacts present:** Yes — `sqli_report.txt` (S25), `xss_payloads.txt` (S26), `api_audit.log` (S27), `OmniPortal_Assessment.md` (TLAB-09)
- **notes.md present:** Yes — shared with Week 8
- **Notes:** All web application security artifacts are present. Week 9 covers SQL injection, XSS, CSRF, API BOLA, and the Operation Omni-Portal full-stack assessment capstone.

---

### Week 10 — Digital Forensics & Incident Response

- **Folder present:** Yes — `week-10_dfir/`
- **Artifacts present:** Yes — `collection_log.txt`, `forensic_findings.md`, `attack_timeline.csv`, `apache_logs`, `forensic_report.pdf`
- **notes.md present:** Yes
- **Notes:** All session and TLAB artifacts are present. Covers live triage and chain of custody (S28), disk and memory forensics (S29), SIEM log correlation with ELK (S30), and the Operation Phantom Pursuit full incident response capstone (TLAB-10).

---

### Week 11 — Active Defense: Firewalls, IDS & EDR

- **Folder present:** Yes — `week-11_active-defense/`
- **Artifacts present:** Yes — `firewall_config.sh`, `custom_ids.rules`, `edr_policy.xml`
- **notes.md present:** Yes
- **Notes:** All session artifacts are present. `Operation_Fortress_Report.md` (TLAB-11) is currently in `week-12_final-reckoning/` and should be relocated to this folder. Covers iptables/UFW firewall engineering (S31), Suricata IDS rule authoring (S32), Sysmon EDR policy deployment (S33), and the Operation Fortress defense-in-depth capstone (TLAB-11).

---

## Repository Standards Check

- **README.md present and complete:** Yes — rebuilt with professional formatting, technology badges, animated header, collapsible weekly sections, and repository structure diagram
- **Repository visibility set to Public:** To be confirmed in GitHub settings before submission
- **All week folders present (week-01 through week-11):** Yes — all present; Weeks 8 and 9 are combined into a single folder
- **notes.md present in every week folder:** Yes — all eleven weeks have complete, APA-style `notes.md` files
- **week-12/ folder contains portfolio_audit.md:** Yes — this document

---

## Professional Reflection

This portfolio represents eleven weeks of hands-on security engineering built entirely in live lab environments — every artifact committed from the command line, every concept applied before it was summarized. The breadth of the work is significant: the same practitioner who wrote `harden.sh` in Week 1 was writing Suricata IDS signatures and Sysmon EDR policies in Week 11, with SQL injection, network pivoting, disk forensics, and Active Directory in between. The work that stands out most is the DFIR arc in Week 10 — particularly the SIEM log correlation exercise, where a breach was reconstructed across three independent log sources by chaining IP pivots — because it demonstrated that security operations is fundamentally an analytical discipline, not just a technical one. Going into Phase 2, the area most worth strengthening is the Active Directory and Windows identity stack from Week 5, which was documented thoroughly but not executed due to VM resource constraints. Completing those labs on proper hardware would close the one significant gap in an otherwise complete portfolio.

---

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5

The Linux Documentation Project. (2024). *The Linux system administrator's guide*. https://tldp.org
