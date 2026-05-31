# Week 3 — Python for Security
## Session Notes

**Course:** Foundations of Cybersecurity  
**Week:** 3 · Sessions 7, 8, 9 · TLAB-03  
**Topics:** Network Port Scanning, Log File Analysis & Brute-Force Detection, Process Auditing & JSON Alerting

---

## Session 07: The Sentry

### Summary

This session introduced Python as a security automation tool, beginning with foundational programming concepts — lists, conditionals, and loops — and culminating in a functional network port scanner. The lab opened with a micro-lab illustrating how logic gates are implemented in code: a list of authorized users was defined and an `if/else` statement was used to grant or deny access based on user input, demonstrating the core logic underlying every firewall and access control system (NIST, 2020).

The primary artifact, `port_check.py`, extended this logic into a practical security tool. Using Python's `socket` library, the script iterated over a list of target IP addresses and attempted a TCP connection to port 22 (SSH) on each host. A timeout of one second was set to prevent indefinite blocking on unreachable hosts. A return code of `0` from `connect_ex()` indicated an open port, while any non-zero result indicated a closed or filtered port. This approach mirrors the foundational logic of network reconnaissance tools and demonstrates how Python can automate repetitive security checks at scale.

### Tools & Commands Used

- `python3` (interactive interpreter) — used for iterative micro-lab exploration of lists and conditionals
- `socket` module — established TCP connections to target hosts on a specified port
- `socket.AF_INET` / `socket.SOCK_STREAM` — configured IPv4 TCP socket parameters
- `s.settimeout(1)` — set a one-second connection timeout to prevent indefinite blocking
- `s.connect_ex()` — attempted port connection and returned a status code without raising exceptions
- `nano` — authored the `port_check.py` script
- `git add`, `git commit`, `git push` — committed and pushed the artifact to the GitHub portfolio

### Artifact

`port_check.py` — A Python network port scanner that iterates over a list of target IP addresses and reports whether port 22 (SSH) is open or closed on each host.

---

## Session 08: The Paper Trail

### Summary

This session introduced Python file I/O and error handling as applied to forensic log analysis. The core concept established was that in cybersecurity, unrecorded events do not exist — a principle that underscores the importance of log management and audit trails in security operations (NIST, 2020). The micro-lab introduced the `with open()` context manager pattern, which ensures file handles are closed properly even in the event of a crash, and demonstrated `try/except` error handling to produce resilient, SOC-grade tooling that fails gracefully rather than crashing when expected files are absent.

The primary artifact, `brute_detector.py`, applied these concepts to a realistic brute-force detection scenario. The script opened a simulated authentication log (`auth_audit.log`) in read mode and a clean report file (`brute_report.txt`) in write mode simultaneously. A `for` loop iterated over every line in the log, and an `if` statement filtered for lines containing the `"Failed password"` signature. Matching lines were written directly to the report file and counted, producing a deduplicated audit artifact and a summary count of detected threat signatures.

### Tools & Commands Used

- `python3` (interactive interpreter) — explored file I/O and error handling concepts incrementally
- `with open()` — opened files using a context manager to ensure safe, automatic file closure
- `try/except FileNotFoundError` — implemented graceful error handling for missing log files
- `for line in log_file` — iterated line-by-line over the authentication log
- `if "Failed password" in line` — filtered log lines by threat signature
- `report_file.write(line)` — wrote matching lines to the clean report artifact
- `nano` — authored the `brute_detector.py` script
- `git add`, `git commit`, `git push` — committed and pushed the artifact to the GitHub portfolio

### Artifact

`brute_detector.py` — A Python log analysis script that reads a system authentication log, filters for failed login attempts, writes matching entries to a clean report file, and outputs a count of detected brute-force signatures.

---

## Session 09: The Conductor

### Summary

This session introduced Python's `subprocess` module for system-level interrogation and the `json` module for structured data export, culminating in an automated threat detection script. The micro-lab demonstrated how to invoke system commands from within Python using `subprocess.run()`, capturing both standard output and error streams as readable text. This capability enables Python scripts to function as orchestration layers — running native system commands and processing their output programmatically rather than requiring manual inspection (NIST, 2020).

The primary artifact, `system_auditor.py`, applied this capability to process monitoring and alerting. The script executed `ps aux` via `subprocess.run()` to capture the full list of running processes, then used an `if` statement to search the output for a specific unauthorized process (`unauthorized_cryptominer`). Upon detection, a Python dictionary was constructed containing the event type, severity level, and process name, and exported to `security_alert.json` using `json.dump()` with formatted indentation. This workflow mirrors the structure of real-world Security Information and Event Management (SIEM) alert pipelines.

### Tools & Commands Used

- `subprocess` module — executed system commands (`uptime`, `ps aux`) from within Python
- `subprocess.run()` with `capture_output=True, text=True` — captured command output as readable strings
- `ps aux` — enumerated all running system processes
- `if "unauthorized_cryptominer" in process_list.stdout` — detected the presence of the threat process
- `json` module — serialized the Python alert dictionary to structured JSON format
- `json.dump()` with `indent=4` — wrote formatted JSON to `security_alert.json`
- `with open()` — safely opened the output file for writing
- `nano` — authored the `system_auditor.py` script
- `git add`, `git commit`, `git push` — committed and pushed the artifact to the GitHub portfolio

### Artifacts

`system_auditor.py` — A Python process auditing script that interrogates the running process list and generates a structured JSON security alert upon detection of an unauthorized process.

`security_alert.json` — The machine-readable JSON alert output generated by `system_auditor.py`, containing the event type, severity classification, and process name of the detected threat.

---

## TLAB-03: Operation Automated Hunt

### Summary

Operation Automated Hunt was an independent end-of-week lab synthesizing file I/O (S08), subprocess execution (S09), and stream parsing (S03) into a fully automated incident response pipeline. The scenario simulated a brute-force attack against a system, with attack evidence embedded in a structured log file at `/var/log/titan_sim/auth_sim.log`. The objective was to write a single Python script that read the log, extracted attacker IP addresses, and exported a structured JSON threat report — without any guided scaffolding (NIST, 2020).

Phase 1 used `subprocess.run()` to execute a `grep` command against the log, filtering for `"Failed password"` entries and capturing the output as a string. Phase 2 applied string parsing logic: the raw output was split into individual lines, each line was tokenized by whitespace, and the IP address at index 10 was extracted and appended to an attacker IP list. This index-based parsing technique directly applied the stream editing concepts from Session 03. Phase 3 structured the extracted data into a Python dictionary with an `alert_type` and `attacker_ips` field, then serialized it to `threat_report.json` using `json.dump()`.

### Tools & Commands Used

- `subprocess.run()` with `grep` — filtered the authentication log for failed login entries
- `raw_output.split('\n')` — tokenized the grep output into a list of individual log lines
- `line.split(" ")[10]` — extracted the IP address field from each parsed log line
- `json` module / `json.dump()` — serialized the attacker IP list into a structured JSON alert file
- `with open()` — safely opened the threat report file for writing
- `python3` — executed the completed script end-to-end
- `git add`, `git commit`, `git push` — committed and pushed both artifacts to the GitHub portfolio

### Artifacts

`incident_response.py` — A Python incident response script that automates log ingestion, IP extraction, and JSON alert generation from a simulated brute-force attack log.

`threat_report.json` — A structured JSON threat report generated by `incident_response.py`, containing the alert type and a list of attacker IP addresses extracted from the authentication log.

---

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5
