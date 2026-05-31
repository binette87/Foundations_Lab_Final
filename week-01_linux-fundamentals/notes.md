# Week 1 — Linux Fundamentals
## Session Notes

**Course:** Foundations of Cybersecurity  
**Week:** 1 · Sessions 1, 2, 3  
**Topics:** Filesystem Navigation, File Permission Hardening, Stream Editing & Automation

---

## Session 01: The Scavenger Hunt

### Summary

This session introduced the Linux Filesystem Hierarchy Standard (FHS) and foundational navigation techniques used in security operations. The objective was to traverse restricted system directories, locate hidden files and directories, and extract sensitive system artifacts as part of a simulated reconnaissance exercise. Navigating the filesystem with precision is a core competency in cybersecurity, as threat actors and defenders alike rely on knowledge of standard Linux directory structures to locate, protect, or exploit system resources (National Institute of Standards and Technology [NIST], 2020).

The lab required navigation to `/var/log` to confirm the presence of system and authentication logs (`syslog` and `auth.log`), both of which are critical sources of forensic evidence during incident response. A mission file was then extracted from `/opt/alpha`, a directory used for optional software installation. Finally, a hidden token was recovered from a concealed directory (`/var/tmp/.blackout`) using the `-la` flag to reveal dot-prefixed hidden entries.

### Tools & Commands Used

- `cd` — changed directories to navigate the filesystem hierarchy
- `ls` / `ls -la` — listed directory contents, including hidden files and detailed permission metadata
- `cat` — read and displayed file contents to the terminal
- `nano` — created and edited `discovery.txt` to document findings
- `git add`, `git commit`, `git push` — committed and pushed the artifact to the GitHub portfolio

### Artifact

`discovery.txt` — A structured report documenting the paths and contents of each recovered system artifact.

---

## Session 02: The Keymaster

### Summary

This session addressed file permission hardening and the principle of least privilege as applied to critical Linux system files. The scenario simulated a misconfiguration introduced by a junior administrator who had set `/etc/shadow` — the file responsible for storing hashed user passwords — to `777`, granting read, write, and execute permissions to all users. This misconfiguration represents a severe security vulnerability, as unrestricted access to `/etc/shadow` exposes every credential on the system to unauthorized disclosure or modification (NIST, 2020).

The remediation process required using `chmod` and `chown` to restore the gold-standard permission posture: `640` ownership by `root:shadow`, limiting read access to privileged processes only. The session also covered hardening of SSH authentication files, specifically `~/.ssh` (set to `700`) and `~/.ssh/authorized_keys` (set to `600`), to prevent unauthorized key-based access. The final artifact was a shell script automating all four hardening commands.

### Tools & Commands Used

- `ls -l` — audited file permissions to identify the misconfiguration
- `sudo chmod` — modified file permission bits to enforce least-privilege access
- `sudo chown` — reassigned file ownership to the appropriate system user and group
- `nano` — authored `harden.sh`, a reusable hardening automation script
- `git add`, `git commit`, `git push` — committed and pushed the artifact to the GitHub portfolio

### Artifact

`harden.sh` — A shell script automating the restoration of secure permission settings for `/etc/shadow` and SSH authentication files.

---

## Session 03: Stream Editing & Automation

### Summary

This session introduced command-line stream editing and pipeline construction as applied to log analysis and threat detection. The scenario simulated an active SQL Injection attack against a web server, with malicious requests containing the `UNION SELECT` signature embedded in an Apache access log. The objective was to identify all unique attacker IP addresses by constructing a multi-stage command pipeline.

Log analysis is a foundational skill in security operations, enabling analysts to rapidly parse high-volume data and isolate indicators of compromise (IOCs) without relying on graphical tools (NIST, 2020). The pipeline constructed in this session demonstrates how `grep`, `awk`, `sort`, and `uniq` can be chained together to extract, transform, and deduplicate data — a workflow directly applicable to real-world threat hunting and incident response.

### Tools & Commands Used

- `grep` — searched the access log for lines containing the `UNION SELECT` SQL injection signature
- `awk '{print $1}'` — extracted the first field (IP address) from each matching log line
- `sort` — sorted the IP address list to prepare it for deduplication
- `uniq` — removed duplicate entries, producing a clean list of unique attacker IPs
- Output redirection (`>`) — wrote the final deduplicated list to `threat_ips.txt`
- `git add`, `git commit`, `git push` — committed and pushed the artifact to the GitHub portfolio

### Artifact

`threat_ips.txt` — A deduplicated list of IP addresses identified as the source of SQL Injection attack traffic, suitable for handoff to a security team for blocking or further investigation.

---

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5
