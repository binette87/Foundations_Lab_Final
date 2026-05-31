# Week 10 — Digital Forensics & Incident Response (DFIR)
## Session Notes

**Course:** Foundations of Cybersecurity  
**Week:** 10 · Sessions 28, 29, 30 · TLAB-10  
**Topics:** Live Triage, Chain of Custody, Cryptographic Hashing, Disk Forensics, Memory Forensics, SIEM Log Correlation
**Topics:** Live Triage, Chain of Custody, Cryptographic Hashing, Disk Forensics, Memory Forensics

---

## Session 28: The Crime Scene

### Summary

This session introduced DFIR (Digital Forensics and Incident Response) as a discipline distinct from offensive security — the goal shifts from exploiting systems to preserving evidence, establishing facts, and maintaining legal defensibility. The two core principles governing all forensic work are: (1) volatility order — collect the most volatile evidence first, because it disappears when power is lost; and (2) chain of custody — every piece of evidence must be cryptographically fingerprinted and documented to prove it has not been tampered with between collection and court or compliance review (NIST, 2020).

**Phase 1 — Live Triage**  
The provisioning script deployed a quarantined Docker container (`compromised_host`) simulating a live server with an active Command and Control (C2) beacon. `docker exec -it compromised_host /bin/sh` accessed the container with a lightweight shell — a deliberate choice over bash, as using the fewest possible tools minimizes the risk of overwriting volatile memory artifacts or modifying file access timestamps. Inside the container, `netstat -antp` displayed all active TCP connections and listening sockets with their associated Process IDs and program names. The investigation focused on identifying a suspicious process listening on port 4444 — the same port used as the Netcat listener in S22 and S24's reverse shell exercises, making it a recognizable C2 indicator. The PID and program name were noted before exiting the container.

The methodology — use native tools, don't install anything, exit cleanly — reflects the principle of minimal footprint forensics. On a real compromised host, installing new software writes to disk, modifies timestamps, and potentially triggers attacker tripwires. Using pre-existing tools (`netstat`, `ps`, `ls`) leaves the smallest possible evidence footprint.

**Phase 2 — Evidence Capture and Chain of Custody**  
The `~/DFIR_Evidence/` directory contained two staged forensic artifacts: `memory_dump.raw` and `system_artifacts.zip`. `md5sum memory_dump.raw` computed the MD5 hash — a 128-bit fingerprint that uniquely identifies the file's contents at the moment of collection. `sha256sum system_artifacts.zip` computed the more cryptographically robust SHA256 hash for the artifact package. Both hashes were recorded in `collection_log.txt` alongside the file names, collection timestamps, and investigator identification — forming the chain of custody record.

MD5 is fast and widely used but is vulnerable to collision attacks (two different files producing the same hash). SHA256 is the current standard for forensic integrity verification because no practical collision attack exists. In real investigations, both are often recorded — MD5 for compatibility with legacy tools and SHA256 for legal defensibility.

The chain of custody record establishes that the evidence has not been altered: at any future point, re-hashing the evidence file must produce the same value. Any difference proves tampering or corruption. This is the foundation of forensic admissibility.

### Tools & Commands Used

- `curl -sL <url> | sudo bash` — provisioned the compromised container and staged forensic evidence
- `docker exec -it compromised_host /bin/sh` — accessed the compromised container with a minimal shell
- `netstat -antp` — enumerated all active TCP connections and listening sockets with PIDs inside the container
  - `-a`: all sockets, `-n`: numeric addresses, `-t`: TCP only, `-p`: show PID/program
- `exit` — cleanly exited the container to the host Ubuntu VM
- `cd ~/DFIR_Evidence/` — navigated to the evidence staging directory
- `ls -la` — listed evidence files with full metadata (permissions, size, timestamps)
- `md5sum memory_dump.raw` — computed the MD5 cryptographic hash of the memory dump
- `sha256sum system_artifacts.zip` — computed the SHA256 cryptographic hash of the artifact package
- `nano ~/collection_log.txt` — completed the chain of custody log with all collected data
- `cat ~/collection_log.txt` — verified the artifact before submission
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`collection_log.txt` — A forensic chain of custody log documenting the compromised container triage findings (suspicious process name and PID on port 4444), the MD5 hash of `memory_dump.raw`, the SHA256 hash of `system_artifacts.zip`, and the collection metadata required to establish evidence integrity.

---

## Key Concepts

**Volatility Order — Evidence Collection Priority**

| Tier | Evidence type | Why it disappears |
|---|---|---|
| Most volatile | CPU registers, cache | Lost on any context switch |
| | Running processes, network connections | Lost on process termination or reboot |
| | Memory (RAM) | Lost on power off |
| | Swap / page file | Overwritten by OS over time |
| Least volatile | Disk (files, logs) | Persists until deleted or overwritten |
| | Backups, cloud storage | Persists indefinitely |

Always collect RAM and network state before touching disk. A reboot destroys all volatile evidence even if the disk is preserved intact.

**Chain of Custody — Why Hashing Matters**

```
Evidence collected → hash computed → hash recorded → evidence stored
                                                            ↓
Later: re-hash the file → compare to recorded hash
  Match   → evidence is unmodified (admissible)
  Mismatch → evidence has been altered (inadmissible)
```

**MD5 vs. SHA256**

| Algorithm | Output size | Speed | Collision resistant | Forensic use |
|---|---|---|---|---|
| MD5 | 128-bit | Fast | No (attacks exist) | Legacy tools, quick checks |
| SHA256 | 256-bit | Moderate | Yes (no known attacks) | Legal/compliance standard |
| SHA3-256 | 256-bit | Moderate | Yes | Emerging standard |

**`netstat -antp` — Flag Breakdown**

```
-a  All sockets (listening + established)
-n  Numeric output (IP addresses, not hostnames — faster, unambiguous)
-t  TCP only (filter out UDP noise)
-p  Show PID and program name (requires root inside the container)
```

**Port 4444 as a C2 Indicator**  
Port 4444 has no standard service assignment and is widely used as a default by Metasploit, Netcat, and common post-exploitation frameworks. Seeing an established or listening connection on 4444 — especially from an unexpected process or one with no legitimate business purpose — is a reliable indicator of compromise and warrants immediate investigation.

---

---

## Session 29: The Digital Autopsy

### Summary

This session introduced the two primary branches of digital forensics: memory forensics (analyzing RAM to find what was running) and disk forensics (analyzing raw storage to find what was deleted). The scenario modeled a real-world malware incident: an employee executed a file named `Resume.exe` that subsequently disappeared. The attacker's assumption — that deletion removes the evidence — is the fundamental misunderstanding this session refuted. Deletion removes a file's directory entry and marks its disk sectors as available, but the data remains physically present until overwritten. Similarly, a process running in RAM leaves artifacts in memory long after it terminates (NIST, 2020).

**Phase 1 — Memory Forensics with Volatility (Simulated)**  
The lab simulated the behavior of Volatility's `pslist` plugin — one of the most commonly used memory forensics commands, which extracts the list of running processes from a memory dump by parsing kernel data structures. In the lab, `strings memdump.raw | grep -i "HIDDEN"` extracted human-readable strings from the raw memory image and filtered for anomalous process indicators. The output identified a hidden process — one with no visible desktop window — along with its PID and executable name. In a full Volatility workflow, `vol.py -f memdump.raw --profile=[OS] pslist` would produce a structured process table; `pstree` would show parent-child relationships that reveal injected or orphaned processes; and `malfind` would scan for memory regions with executable code injected by malware.

**Phase 2 — Disk Forensics with The Sleuth Kit**  
The Sleuth Kit (TSK) is an open-source forensic toolkit that reads raw disk images at the sector level, bypassing the operating system entirely. `fls -r compromised_drive.dd` listed all files and directories in the disk image — both active and deleted. Deleted files appear with an asterisk (`*`) preceding their inode number, indicating the directory entry has been removed but the inode and data blocks are still present on disk. The deleted `Resume.exe` was located in the output. `icat compromised_drive.dd [INODE]` extracted the raw file data by reading the disk blocks referenced by that inode directly, without relying on the filesystem's directory structure. The recovered payload was redirected to `recovered_malware.txt` and examined with `cat`, revealing how the malware operated.

The forensic findings report `forensic_findings.md` was completed with four fields: WHO (the process or actor), WHAT (the malware's behavior), WHEN (timestamp evidence), and HOW (the infection mechanism recovered from the payload content). This four-field framework maps directly to the standard incident response narrative required in legal proceedings and regulatory reporting.

### Tools & Commands Used

- `curl -sL <url> | sudo bash` — installed forensic tooling, generated `memdump.raw`, and built `compromised_drive.dd`
- `cd ~/DFIR_Evidence/` — navigated to the evidence directory
- `strings memdump.raw | grep -i "HIDDEN"` — extracted readable strings from the memory dump and filtered for hidden process indicators
- `fls -r compromised_drive.dd` — listed all files (active and deleted) recursively in the raw disk image
  - `-r`: recursive traversal; deleted files marked with `*` before inode number
- `icat compromised_drive.dd [INODE]` — extracted the raw data of the deleted file by inode number
- `> recovered_malware.txt` — redirected the recovered file data to a named output file
- `cat recovered_malware.txt` — examined the recovered malware payload
- `nano ~/forensic_findings.md` — completed the WHO/WHAT/WHEN/HOW forensic findings report
- `cat ~/forensic_findings.md` — verified the artifact before submission
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`forensic_findings.md` — A forensic findings report structured around the WHO/WHAT/WHEN/HOW framework, documenting the hidden process identified from memory analysis and the malware behavior recovered from the deleted `Resume.exe` payload via inode-level disk carving.

---

## Key Concepts

**Why Deleted Files Are Recoverable**  
When a file is deleted, the operating system removes the directory entry (the filename pointer) and marks the inode and data blocks as free — available for reuse. The actual data in those blocks is not zeroed or overwritten. Until the OS allocates those blocks to a new file, the deleted file's content remains physically present on the disk. Forensic tools like `icat` bypass the filesystem's "available" label and read the blocks directly.

**The Sleuth Kit — Core Tools**

| Tool | Function |
|---|---|
| `fls` | List files and directories in a disk image, including deleted entries |
| `icat` | Extract file content by inode number, bypassing directory structure |
| `istat` | Display inode metadata (timestamps, block allocation) |
| `fsstat` | Display filesystem-level statistics and geometry |
| `mmls` | List partition table entries in a disk image |

**Volatility — Key Plugins for Malware Triage**

| Plugin | What it reveals |
|---|---|
| `pslist` | Running processes (from kernel process list) |
| `pstree` | Process hierarchy — orphaned processes indicate injection |
| `malfind` | Memory regions with suspicious executable code |
| `netscan` | Active and recently closed network connections |
| `cmdline` | Command-line arguments for each process |
| `dlllist` | DLLs loaded by each process — unusual DLLs = red flag |

**`strings` + `grep` as a Quick Memory Triage Tool**  
`strings` extracts all sequences of printable characters above a minimum length from any binary file — including raw memory dumps. Piping to `grep` filters for specific indicators: process names, IP addresses, URLs, registry keys, or custom strings. This is a fast triage technique when a full Volatility analysis is not immediately available.

**The Four-Field Forensic Narrative**

| Field | Question answered | Source |
|---|---|---|
| WHO | Which actor or process | Memory: process name, PID, parent PID |
| WHAT | What the malware did | Disk: recovered payload behavior |
| WHEN | Timeline of activity | Filesystem: inode timestamps (MAC times) |
| HOW | Infection mechanism | Payload content: scripts, commands, callbacks |

---

---

## Session 30: The Central Nervous System

### Summary

This session introduced Security Information and Event Management (SIEM) as the centralized log correlation platform used in enterprise security operations. Where S28–29 focused on single-host forensics, a SIEM aggregates logs from every system in the environment — web servers, domain controllers, firewalls, endpoints — and makes them searchable in real time. The scenario required reconstructing an attacker's full kill chain across multiple disparate log sources by correlating events on IP address and timestamp — the same technique used by SOC analysts during active incident investigations (NIST, 2020).

The lab deployed a local resource-optimized ELK stack (Elasticsearch, Logstash, Kibana) with pre-injected enterprise log data. Kibana served as the analyst interface at `http://localhost:5601`.

**Phase 1 — Kibana Search (Initial Indicator Discovery)**  
After configuring the `enterprise_logs*` index pattern in Stack Management, the Discover tab provided a full-text search interface over all ingested logs. Querying `event_type: "Failed Login"` filtered to authentication failure events. Expanding a log entry revealed an external `source_ip` — the attacker's originating address — which served as the thread to pull for the rest of the investigation. This is the standard starting point in a real SOC: a failed login alert fires, an analyst pivots on the source IP, and the full story unfolds from there.

**Phase 2 — Timeline Reconstruction via Log Correlation**  
The deep dive followed the attacker's IP across three distinct log sources, each revealing a different phase of the attack.

*Initial Access:* Querying the external source IP in the web server logs revealed the exact timestamp and the command the attacker executed — the moment of first foothold.

*Lateral Movement:* Searching for `"Domain Admin"` in the Windows Security logs showed the attacker escalating privileges and moving from the web server to an internal host. The internal IP used for lateral movement was extracted from these logs.

*Exfiltration:* Querying the internal IP in the firewall logs revealed anomalous outbound traffic — an unusually large data transfer that did not match normal baseline behavior. The timestamp and data volume were recorded as the exfiltration event.

All three events — with their timestamps, IP addresses, event types, and descriptions — were compiled into `attack_timeline.csv`, a structured breach timeline suitable for incident reporting, insurance claims, regulatory notification, or legal proceedings.

### Tools & Commands Used

- `curl -sL <url> | tr -d '\r' | sudo bash` — deployed the local ELK stack and injected enterprise log data
- **Kibana** (`http://localhost:5601`) — primary SIEM interface
  - **Stack Management → Index Patterns** — configured `enterprise_logs*` as the index pattern
  - **Discover tab** — performed log searches and timeline analysis
- `event_type: "Failed Login"` — Kibana query to find authentication failure events
- External source IP pivot — correlated all log sources on the attacker's IP address
- `"Domain Admin"` — Kibana search string to find privilege escalation and lateral movement events in Windows Security logs
- Internal IP pivot — correlated firewall logs to find exfiltration traffic
- `nano ~/attack_timeline.csv` — completed the three-phase attack timeline artifact
- `cat ~/attack_timeline.csv` — verified the artifact before submission
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`attack_timeline.csv` — A structured attack timeline documenting all three phases of the reconstructed breach — Initial Access, Lateral Movement, and Exfiltration — with timestamps, source and destination IP addresses, event types, and narrative descriptions derived from correlated SIEM log queries.

---

## Key Concepts

**The ELK Stack**

| Component | Role |
|---|---|
| **Elasticsearch** | Distributed search and analytics engine — stores and indexes all log data |
| **Logstash** | Log ingestion pipeline — parses, transforms, and forwards logs to Elasticsearch |
| **Kibana** | Visualization and query interface — search, dashboards, alerting |

Together, ELK functions as a SIEM: a single platform where every log source in the environment is searchable, correlatable, and visualizable.

**Log Correlation — The Core SIEM Skill**  
A single log source tells one part of the story. Correlation tells the whole story. The attack timeline reconstruction required three pivots:

```
Failed Login alert → source_ip extracted
  ↓
Web server logs (source_ip) → command executed, timestamp
  ↓
Windows Security logs ("Domain Admin") → internal_ip, lateral movement
  ↓
Firewall logs (internal_ip) → outbound data volume, exfiltration timestamp
```

Each pivot used data from the previous step to filter the next query — the same chain-of-evidence reasoning as physical forensics, applied to log data.

**Kibana Query Syntax (KQL)**  
Kibana Query Language (KQL) is the search syntax used in the Discover tab:

```
event_type: "Failed Login"          # exact match on field value
source_ip: "203.0.113.45"           # filter by IP address
message: "Domain Admin"             # full-text search in message field
@timestamp >= "2024-01-01T00:00:00" # time range filter
```

Combining field filters with boolean operators (`AND`, `OR`, `NOT`) allows precise multi-condition queries across millions of log events.

**Why SIEM Is Essential for Incident Response**  
Without a SIEM, reconstructing a multi-host attack requires manually collecting and cross-referencing log files from each individual system — a process that takes hours or days and is prone to missing connections. A SIEM makes the same reconstruction possible in minutes because all logs share a common index, a common timestamp format, and a common query interface. Speed matters in incident response: every hour an attacker remains in the network is more time for lateral movement, data theft, and persistence installation.

---

---

## TLAB-10: Operation Phantom Pursuit

### Summary

Operation Phantom Pursuit was the Week 10 capstone, chaining all three DFIR disciplines — SIEM correlation (S30), live host triage and chain of custody (S28), and disk forensics (S29) — into a single end-to-end incident response investigation. The scenario placed the analyst as Lead Incident Responder across a full breach lifecycle: from the initial SIEM alert through live triage to deleted payload recovery. The deliverable was a formal `Incident_Response_Report.md` structured across three phases, suitable for submission to legal, compliance, or executive stakeholders (NIST, 2020).

**Phase 1 — SIEM Correlation**  
Kibana was accessed at `http://localhost:5601` with the `enterprise_logs*` index pattern configured. A search for `Critical Alert` in the Discover tab surfaced the initial alert log entry. Expanding the entry revealed the `source_ip` — the attacker's originating address — which was recorded as the Phase 1 finding and served as the pivot for subsequent investigation steps.

**Phase 2 — Live Triage and Chain of Custody**  
`docker exec -it quarantined_host /bin/sh` accessed the compromised container with a minimal shell. `netstat -antp` enumerated active connections and listening sockets, identifying the suspicious process on port 4444 and its PID. After exiting the container, `sha256sum compromised_drive.dd` was computed from `~/DFIR_Evidence/` — establishing the cryptographic chain of custody fingerprint for the disk image. Both the PID and the SHA256 hash were recorded in Phase 2 of the report.

**Phase 3 — Disk Autopsy**  
`fls -r compromised_drive.dd` listed all files in the disk image recursively, including deleted entries marked with an asterisk. The deleted `beacon.exe` — the malware payload the attacker attempted to hide — was located by its inode number. `icat compromised_drive.dd [INODE]` extracted the raw file data, redirected to `recovered_payload.txt`. `cat recovered_payload.txt` revealed the payload contents, which were pasted verbatim into Phase 3 of the report as forensic evidence.

### Tools & Commands Used

- `curl -sL <url> | tr -d '\r' | sudo bash` — deployed ELK SIEM, triage container, and disk image
- **Kibana** (`http://localhost:5601`) — SIEM interface for alert discovery
  - `enterprise_logs*` index pattern
  - `Critical Alert` search query → `source_ip` extracted
- `docker exec -it quarantined_host /bin/sh` — accessed the live compromised container
- `netstat -antp` — identified the C2 process and PID on port 4444
- `exit` — cleanly exited the container
- `cd ~/DFIR_Evidence/` — navigated to the evidence directory
- `sha256sum compromised_drive.dd` — computed the chain of custody hash for the disk image
- `fls -r compromised_drive.dd` — listed all files including deleted entries
- `icat compromised_drive.dd [INODE] > recovered_payload.txt` — extracted the deleted `beacon.exe` by inode
- `cat recovered_payload.txt` — examined the recovered malware payload
- `nano ~/Incident_Response_Report.md` — completed the three-phase incident response report
- `cat ~/Incident_Response_Report.md` — verified all phases before submission
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`Incident_Response_Report.md` — A three-phase formal incident response report covering the full breach lifecycle: SIEM alert source IP identification, live triage PID and SHA256 chain of custody hash, and deleted `beacon.exe` payload recovery and contents — structured for legal, compliance, and executive reporting.

---

## Full DFIR Methodology Summary (Week 10)

```
S28: Live Triage + Chain of Custody
  └── netstat → C2 process on port 4444
  └── md5sum / sha256sum → evidence integrity fingerprints

S29: Disk & Memory Forensics
  ├── strings + grep → hidden process in RAM
  └── fls → deleted file inode
      └── icat → recovered payload (Resume.exe)

S30: SIEM Log Correlation
  └── Kibana: Failed Login → source_ip
      └── Web server logs → Initial Access
          └── Windows Security logs → Lateral Movement
              └── Firewall logs → Exfiltration timestamp + volume

TLAB-10: Full Breach Lifecycle (all three combined)
  └── Critical Alert → source_ip
      └── Live triage → PID on port 4444
          └── SHA256 chain of custody
              └── fls → beacon.exe inode → icat → payload recovered
```

---

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5
