# Week 6 — Midterm Capstone & OSI Troubleshooting
## Session Notes

**Course:** Foundations of Cybersecurity  
**Week:** 6 · Sessions 16, 17 · TLAB-06  
**Topics:** OSI Model Troubleshooting, File Permissions, Docker Port Conflicts, Firewall Rules

---

## Session 16: The Architect's War Room

### Summary

This session applied the OSI model as a structured diagnostic framework for triaging real system failures. The core methodology was outside-in troubleshooting: when a system is broken, start at the highest layer (Layer 7 — Application) and work down, or start at the network layer and work up, isolating the failure to a specific layer before attempting a fix. This prevents wasted effort — applying an application-level fix to what is actually a firewall rule, or vice versa (NIST, 2020). The lab presented three distinct anomalies, each mapped to a different OSI layer, requiring different diagnostic tools and fixes.

The environment was prepared by a sabotage script that deliberately introduced all three failures simultaneously, simulating a real-world scenario where multiple unrelated issues appear at the same time and must be isolated and resolved independently.

**Anomaly 1 — The Dead Diagnostic (Layer 7: Application)**  
Attempting to run `~/forge_v1/broken_script.sh` produced `Permission denied`. `ls -la ~/forge_v1/` revealed a permission string of `----------` — every permission bit stripped. This is a Layer 7 failure: the application (the shell script) cannot execute because the filesystem has removed the execute bit. `chmod 755 broken_script.sh` restored owner read/write/execute and group/other read/execute. Re-running the script produced `[+] Heartbeat Detected`, confirming the fix.

**Anomaly 2 — The Doorway Conflict (Layer 4: Transport)**  
Launching an Apache httpd container with `-p 8080:80` produced `Bind for 0.0.0.0:8080 failed: port is already allocated`. This is a Layer 4 failure: a port (a Transport layer construct) was already bound by another process. `sudo docker ps` identified the offending container as `ghost_web`. `sudo ss -tlnp | grep 8080` could also confirm which process held the socket. `sudo docker rm -f ghost_web` forcibly stopped and removed the ghost container, freeing the port. Re-running the `docker run` command succeeded.

**Anomaly 3 — The Silent Heartbeat (Layer 3: Network)**  
Running `ping 8.8.8.8` produced `Operation not permitted`. Since ping is a Layer 3 tool (it uses ICMP, an Internet layer protocol), a failure here points to a network-layer block. `sudo ufw status numbered` listed the active firewall rules and revealed a `DENY OUT` rule targeting ICMP. `sudo ufw delete [rule number]` removed the blocking rule. `ping -c 4 8.8.8.8` then succeeded, confirming outbound ICMP was restored.

The session concluded with `readiness_check.log` — a self-assessment artifact documenting the analyst's confidence across the OSI troubleshooting skills covered, completed in Nano and pushed to GitHub.

### Tools & Commands Used

- `curl -sL <url> | sudo bash` — ran the TA's sabotage provisioning script to introduce all three anomalies
- `~/forge_v1/broken_script.sh` — attempted execution; revealed `Permission denied` (Anomaly 1)
- `ls -la ~/forge_v1/` — inspected file permissions; observed `----------` permission string
- `chmod 755 broken_script.sh` — restored owner rwx, group/other rx permissions on the script
- `docker run -d -p 8080:80 httpd` — attempted container launch; produced port conflict error (Anomaly 2)
- `sudo docker ps` — listed running containers; identified `ghost_web` squatting on port 8080
- `sudo ss -tlnp` — listed listening TCP sockets with process IDs; used to confirm which process held port 8080
- `sudo ss -tlnp | grep 8080` — filtered socket output to isolate the port 8080 binding
- `sudo docker rm -f ghost_web` — forcibly stopped and removed the ghost container
- `ping 8.8.8.8` — produced `Operation not permitted` due to firewall DENY rule (Anomaly 3)
- `sudo ufw status numbered` — listed all firewall rules with index numbers; identified ICMP DENY OUT rule
- `sudo ufw delete [rule number]` — removed the blocking firewall rule
- `ping -c 4 8.8.8.8` — verified Layer 3 connectivity was restored
- `nano ~/readiness_check.log` — completed the self-assessment readiness artifact
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`readiness_check.log` — A self-assessment readiness log documenting confidence levels and understanding of OSI-layer troubleshooting techniques covered in Session 16, submitted as the midterm capstone check-in artifact.

---

## Key Concepts

**OSI Troubleshooting Framework — Outside-In**

| OSI Layer | # | What it controls | Diagnostic tool | S16 Anomaly |
|---|---|---|---|---|
| Application | 7 | App behavior, protocols | Script output, app logs | `chmod` — broken_script.sh |
| Presentation | 6 | Encoding, encryption | — | — |
| Session | 5 | Session management | — | — |
| Transport | 4 | Ports, TCP/UDP | `ss`, `nc`, `docker ps` | Port conflict — ghost_web |
| Network | 3 | IP routing, ICMP | `ping`, `ufw`, `traceroute` | ICMP block — ufw DENY rule |
| Data Link | 2 | MAC, switching | `ip link`, `arp` | — |
| Physical | 1 | Cables, signals | Hardware inspection | — |

**`chmod 755` — Permission Breakdown**

```
7 = rwx  (owner: read + write + execute)
5 = r-x  (group: read + execute)
5 = r-x  (other: read + execute)
```

The sabotage set permissions to `000` (`----------`), removing all access for all users including the owner. Without the execute bit, the kernel refuses to run the file regardless of its content.

**`ss -tlnp` vs. `netstat`**  
`netstat` is deprecated on modern Linux systems. `ss` (socket statistics) is its replacement and is faster, more feature-rich, and available by default on Ubuntu. The flags `-tlnp` combine to show only listening TCP sockets with numeric addresses and the owning process — the exact information needed to identify what is holding a port.

**`nc` (Netcat) for Layer 4 Verification**  
`nc -zv [IP] [PORT]` tests port reachability without sending application data. If `ss` shows a port is listening but `nc` from a remote host fails, the packet is being dropped at the firewall (Layer 3/4) before it reaches the socket. This distinction is critical: the service is running, but the network path is blocked.

**`ufw` Rule Numbering**  
`sudo ufw status numbered` displays rules with index numbers, enabling safe targeted deletion with `sudo ufw delete [n]`. Deleting by rule number avoids accidental removal of the wrong rule when multiple similar rules exist. Always run `status numbered` and identify the exact rule before deleting.

---

---

## Session 17: The Forge Final

### Summary

Session 17 was the midterm capstone practical exam, consisting of two phases: a theoretical diagnostic (Part A, administered through Canvas) and a hands-on practical diagnostic (Part B, conducted on the Ubuntu VM). The practical phase simulated a realistic SOC task: locating sensitive root-owned log files scattered across the filesystem, extracting them to a controlled submission directory, and locking them down to read-only before documenting every command used in a structured exam report.

Part B began with a filesystem hunt using the `find` command — one of the most powerful forensic and administrative tools in Linux. The command searched the entire root filesystem (`/`) for files matching two criteria: owned by `root` (`-user root`) and having a `.log` extension (`-name "*.log"`). Standard error was redirected to `/dev/null` using `2>/dev/null` to suppress permission-denied messages from protected directories, keeping the output clean and readable. This technique is standard practice during forensic searches where the analyst needs results without noise from inaccessible paths.

The located files — `forge_alpha.log` and `forge_beta.log` — were moved into `~/Exam_Submission/` using `sudo mv`. The `sudo` requirement enforced the principle that root-owned files cannot be manipulated by a regular user without explicit privilege escalation — a deliberate constraint demonstrating awareness of Linux ownership and privilege boundaries.

Permissions were then changed to `444` using `sudo chmod 444`, setting the files to read-only for owner, group, and other — removing all write and execute permissions across the board. This lockdown step simulates evidence preservation: once forensic artifacts are collected, they must be write-protected to maintain chain of custody and prevent accidental or intentional modification (NIST, 2020).

All commands used across the three steps were documented verbatim in `practical_exam_report.txt`, which served as both the submission artifact and a chain-of-custody record — a format directly analogous to real-world incident response documentation where exact commands must be reproducible and auditable.

### Tools & Commands Used

- `curl -sL <url> | sudo bash` — ran the exam provisioning script to create `~/Exam_Submission/` and seed the environment
- `find / -user root -name "*.log" 2>/dev/null` — searched the entire filesystem for root-owned `.log` files while suppressing permission errors
- `sudo mv forge_alpha.log forge_beta.log ~/Exam_Submission/` — moved the discovered log files into the submission directory using elevated privileges
- `sudo chmod 444 ~/Exam_Submission/forge_alpha.log ~/Exam_Submission/forge_beta.log` — set both files to read-only for all users
- `cat ~/practical_exam_report.txt` — verified the completed report before submission
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`practical_exam_report.txt` — The midterm practical exam report documenting the exact commands used to locate root-owned log files across the filesystem, extract them to the submission directory, and lock them to read-only — serving as both an exam submission and a chain-of-custody record.

---

## Key Concepts

**`find` — Filesystem Search Syntax**

```bash
find [start_path] [criteria] [action]

# S17 command:
find / -user root -name "*.log" 2>/dev/null
```

Common criteria flags: `-user` (file owner), `-name` (filename pattern, case-sensitive), `-iname` (case-insensitive), `-type f` (files only), `-type d` (directories only), `-perm` (permission bits), `-mtime` (modified within N days). Combining criteria with `-and` / `-or` enables complex forensic queries.

**`2>/dev/null` — Silencing Permission Errors**  
File descriptor `2` is standard error (stderr). Redirecting it to `/dev/null` (the system's discard device) suppresses error messages without affecting standard output (fd `1`). During a filesystem-wide `find`, hundreds of `Permission denied` messages would otherwise drown out the actual results. This redirection is a standard forensic search technique, not a workaround.

**`chmod 444` — Read-Only for All**

```
4 = r--  (owner: read only)
4 = r--  (group: read only)
4 = r--  (other: read only)
```

Setting evidence files to `444` immediately after collection prevents any user — including the analyst — from accidentally modifying the artifact. Combined with a cryptographic hash (`sha256sum`) taken at collection time, this establishes the integrity baseline required for chain of custody in a formal investigation.

**Why `sudo mv` for Root-Owned Files**  
A file owned by `root` can only be moved or deleted by `root` (or a user with sudo). A regular user attempting `mv` on a root-owned file in a protected directory will receive `Permission denied` regardless of the destination. This is a deliberate Linux security boundary: ownership controls who can manipulate a file, not just who can read it.

---

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5
