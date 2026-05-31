# Week 10 — Digital Forensics & Incident Response (DFIR)
## Session Notes

**Course:** Foundations of Cybersecurity  
**Week:** 10 · Sessions 28, 29 · TLAB-10  
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

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5
