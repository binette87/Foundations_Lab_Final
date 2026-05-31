# Week 11 — Active Defense
## Session Notes

**Course:** Foundations of Cybersecurity  
**Week:** 11 · Sessions 31, 32, 33 · TLAB-11  
**Topics:** Firewall Configuration, UFW, iptables, DMZ Architecture, Intrusion Detection, EDR

---

## Session 31: The Barricade

### Summary

This session introduced host-based firewall engineering as an active defense discipline — configuring rules that define exactly which traffic is permitted and which is dropped, at both the user-friendly abstraction layer (UFW) and the raw packet filter layer (iptables). The scenario involved hardening a corporate web server in a DMZ: allowing legitimate web traffic in while preventing a compromised web server from being used as a pivot point to reach the internal database network (NIST, 2020).

The key architectural concept was the DMZ (Demilitarized Zone) — a network segment that sits between the internet and the internal network. Hosts in the DMZ (web servers, mail servers, public APIs) are accessible from the internet but should have strictly limited connectivity to internal systems. If a DMZ host is compromised, proper egress rules on that host prevent the attacker from using it as a bridge into the internal network. This is defense-in-depth: the firewall on the DMZ host is the last line of protection even after the host itself is breached.

**Phase 1 — UFW Default Deny**  
Inside the `dmz_web` container, UFW was configured with a default-deny posture: `ufw default deny incoming` blocks all inbound traffic unless explicitly allowed; `ufw default allow outgoing` permits outbound connections (standard for servers that initiate update downloads and DNS queries). Ports 22 (SSH) and 443 (HTTPS) were explicitly opened. `ufw enable` activated the ruleset and `ufw status verbose` confirmed the active rules. UFW was then disabled before Phase 2 — iptables and UFW both manage `netfilter` (the Linux kernel's packet filtering framework), and running both simultaneously can produce conflicting rules.

**Phase 2 — iptables DMZ Lockdown**  
Three iptables rules were engineered to enforce DMZ segmentation at the packet level:

Rule 1 (`INPUT ACCEPT`) permitted inbound HTTP and HTTPS traffic from the internet using the `multiport` extension to match both ports in a single rule.

Rule 2 (`OUTPUT ACCEPT`) created a narrow egress exception: the web server was explicitly allowed to communicate with the internal database at `10.0.5.50` on port 3306 (MySQL/MariaDB) — the only legitimate business reason for the web server to reach the internal subnet.

Rule 3 (`OUTPUT DROP`) blocked all other outbound traffic destined for the `10.0.5.0/24` internal subnet. Combined with Rule 2, this produces a precise allowlist: the web server can reach the database on exactly one port; all other internal connectivity is blocked. An attacker who compromises the web server cannot pivot to other internal hosts, cannot run port scans against the internal network, and cannot exfiltrate data to other internal systems.

The three rules were inserted into the `~/firewall_config.sh` script template on the host VM, making the entire DMZ lockdown reproducible and version-controlled.

### Tools & Commands Used

- `curl -sL <url> | tr -d '\r' | sudo bash` — provisioned the containerized DMZ environment and script template
- `docker exec -it dmz_web /bin/bash` — accessed the DMZ web server container as root
- `ufw default deny incoming` — set the default inbound policy to DROP
- `ufw default allow outgoing` — set the default outbound policy to ACCEPT
- `ufw allow 22/tcp` — explicitly permitted SSH
- `ufw allow 443/tcp` — explicitly permitted HTTPS
- `ufw enable` — activated the UFW ruleset
- `ufw status verbose` — displayed all active rules and default policies
- `ufw disable` — deactivated UFW before switching to raw iptables
- `iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT` — allowed HTTP/HTTPS inbound
- `iptables -A OUTPUT -p tcp -d 10.0.5.50 --dport 3306 -j ACCEPT` — allowed web server → database on MySQL port only
- `iptables -A OUTPUT -d 10.0.5.0/24 -j DROP` — blocked all other outbound traffic to the internal subnet
- `iptables -L -v -n` — listed all active iptables rules with packet/byte counters
- `exit` — exited the container
- `nano ~/firewall_config.sh` — inserted the three iptables rules into the script template
- `cat ~/firewall_config.sh` — verified the artifact before submission
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`firewall_config.sh` — A firewall configuration script implementing the DMZ lockdown: UFW default-deny setup for SSH/HTTPS, and three iptables rules enforcing inbound web traffic allowance, targeted database egress, and full internal subnet DROP for all other outbound connections.

---

## Key Concepts

**UFW vs. iptables**

| | UFW | iptables |
|---|---|---|
| Abstraction | High-level, human-readable | Low-level, rule-by-rule packet matching |
| Use case | Quick server hardening | Complex network policies, DMZ rules |
| Underlying engine | Both manage Linux `netfilter` | Directly controls `netfilter` |
| Conflict risk | Running both simultaneously can produce conflicting rules | — |

**iptables Rule Order — Why It Matters**  
iptables evaluates rules in the order they appear in each chain and stops at the first match. Rule 2 (ACCEPT to `10.0.5.50:3306`) must appear before Rule 3 (DROP to `10.0.5.0/24`), because the DROP rule would otherwise catch the database traffic before it reaches the ACCEPT rule. The order `ACCEPT specific → DROP broad` is the correct pattern for allowlist-style egress control.

**DMZ Architecture — Defense-in-Depth**

```
Internet
   │
[UFW: deny incoming / allow 22, 443]
   │
DMZ Web Server (dmz_web)
   │
[iptables: ACCEPT 10.0.5.50:3306 / DROP 10.0.5.0/24]
   │
Internal Subnet (10.0.5.0/24)
   └── Database (10.0.5.50:3306)  ← only reachable from web server, only on port 3306
   └── Other internal hosts       ← completely unreachable from DMZ
```

**`-m multiport --dports 80,443`**  
The `multiport` iptables extension allows matching multiple ports in a single rule rather than writing a separate rule for each port. `--dports 80,443` matches destination port 80 OR 443, equivalent to two separate `-p tcp --dport` rules combined.

---

---

## Session 32: The Tripwire

### Summary

This session introduced Intrusion Detection Systems (IDS) through hands-on Suricata rule authoring and signature verification. Where firewalls (S31) block traffic based on port and protocol, an IDS inspects the content of traffic and fires alerts when patterns match known threat signatures. The two technologies are complementary: firewalls reduce the attack surface; IDS monitors what gets through and raises alerts when suspicious behavior is detected. Suricata is a high-performance, open-source IDS/IPS engine that can process network traffic at line rate and apply custom rules to any layer of the network stack (NIST, 2020).

The lab was structured as a write-deploy-trigger-verify cycle for each rule — the standard workflow for validating that a signature correctly detects its intended threat and does not produce false positives.

**Phase 1 — ICMP Detection (Network Layer)**  
The first rule detected ICMP ping activity directed at the web server at `172.90.0.10`. The rule `alert icmp any any -> 172.90.0.10 any` matched any ICMP packet from any source to the target IP on any ICMP type. The `msg` field provided the human-readable alert description, `sid` assigned a unique rule identifier, and `rev` tracked the rule version. Suricata was deployed as a Docker container with the custom rules file and log directory mounted as volumes, and instructed to listen on the `ids_net` Docker network interface. A single ping confirmed the rule fired; `cat ~/IDS_Lab/logs/fast.log` showed the alert entry.

**Phase 2 — Application-Layer Malware Signature**  
The second rule demonstrated content-based detection at Layer 7. The rule `alert tcp any any -> 172.90.0.10 80 (content:"Ghost_Scanner_v1"; ...)` matched TCP traffic to port 80 containing the exact string `Ghost_Scanner_v1` — a hardcoded User-Agent string used by a simulated threat actor's scanner. The attack was simulated with `curl -A "Ghost_Scanner_v1" http://172.90.0.10`, which sent an HTTP request with that string in the User-Agent header. Suricata matched the content string in the TCP payload and fired the alert. The Suricata container was restarted between rule updates to reload the rule file.

### Tools & Commands Used

- `curl -sL <url> | sudo bash` — provisioned the IDS staging directory, target web server, and rule template
- `nano ~/IDS_Lab/custom_ids.rules` — authored the Suricata detection rules
- `alert icmp any any -> 172.90.0.10 any (msg:"ICMP Ping Detected"; sid:1000001; rev:1;)` — Rule 1: ICMP ping detection
- `alert tcp any any -> 172.90.0.10 80 (msg:"Ghost_Bear Malware Scanner Detected"; content:"Ghost_Scanner_v1"; sid:1000002; rev:1;)` — Rule 2: malware User-Agent content match
- `docker run -d --name ids_sensor --net ids_net -v [rules]:/etc/suricata/custom.rules -v [logs]:/var/log/suricata jasonish/suricata:latest -S /etc/suricata/custom.rules -i eth0` — deployed Suricata with custom rules mounted
- `ping -c 1 172.90.0.10` — triggered the ICMP rule
- `cat ~/IDS_Lab/logs/fast.log` — verified the alert fired after each test
- `docker restart ids_sensor` — reloaded the Suricata container to ingest updated rules
- `curl -A "Ghost_Scanner_v1" http://172.90.0.10` — simulated the malware scanner with a spoofed User-Agent
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`custom_ids.rules` — A Suricata IDS rule file containing two custom signatures: an ICMP ping detection rule targeting the protected web server, and a TCP content-match rule detecting the `Ghost_Scanner_v1` malware User-Agent string on port 80.

---

## Key Concepts

**Suricata Rule Anatomy**

```
alert tcp any any -> 172.90.0.10 80 (msg:"Description"; content:"string"; sid:1000002; rev:1;)
│     │   │   │    │  │           │   │                  │                   │          │
│     │   │   │    │  │           │   msg: alert label   content: payload    sid: rule  rev: version
│     │   │   │    │  │           └── destination port
│     │   │   │    └─ destination IP
│     │   └───┴────── source IP : source port (any = all)
│     └── protocol (tcp, udp, icmp, http, dns, etc.)
└── action (alert, drop, pass, reject)
```

**IDS vs. IPS**

| Mode | Action on match | Effect |
|---|---|---|
| IDS (Detection) | Generate alert, log event | Traffic passes — analyst is notified |
| IPS (Prevention) | Drop packet + alert | Traffic is blocked in real time |

Suricata supports both modes. In IDS mode (`-S` flag with `alert` rules) it monitors passively. In IPS mode (inline with `drop` rules) it actively blocks matched traffic.

**`content` Keyword — Application-Layer Matching**  
The `content` keyword tells Suricata to search the packet payload for an exact byte sequence. This is how signature-based IDS detects known malware: attackers often hardcode strings in their tools (User-Agent headers, command strings, protocol keywords) that can be matched reliably. The limitation is that content matching is bypassable by encoding or obfuscating the target string — which is why modern IDS also uses behavioral analysis and anomaly detection alongside signature rules.

**SID Namespace Convention**  
Suricata rule SIDs are divided into ranges by origin: SIDs 1–999,999 are reserved for official rulesets (ET Open, Snort VRT). Custom local rules should use SIDs ≥ 1,000,000 to avoid conflicts with official rule updates. The lab used `sid:1000001` and `sid:1000002` following this convention.

---

---

## Session 33: The Last Mile

### Summary

This session introduced Endpoint Detection and Response (EDR) through Sysmon — Microsoft's free endpoint monitoring tool — and XML-based detection policy authoring. Where IDS (S32) monitors network traffic, EDR monitors what happens on the host itself: which processes are created, which files are accessed, which commands are executed. This distinction is critical for detecting threats that operate entirely within a single machine, such as ransomware precursor behavior, living-off-the-land attacks, and obfuscated scripts (NIST, 2020).

**Phase 1 — Sysmon Process Monitoring**  
Sysmon was initialized on the Ubuntu VM using SysmonForLinux (`sudo sysmon -accepteula -i`), which begins logging all process creation events to the system log at `/var/log/syslog`. Event ID 1 (Process Creation) is Sysmon's most important event type — it records the full command line, parent process, and user context for every process that starts on the endpoint.

A simulated suspicious script (`invoice_macro.ps1`) was executed via PowerShell Core (`pwsh`). The script claimed to download an invoice, but Sysmon's Event ID 1 logs revealed its actual behavior: `pwsh` spawned a child process whose command line contained `vssadmin delete shadows /all /quiet`. This command — deleting Volume Shadow Copies — is the canonical ransomware precursor step. Shadow copies are Windows' built-in backup mechanism; ransomware deletes them immediately before beginning encryption to prevent victims from recovering files without paying the ransom. Detecting this command is therefore a high-confidence indicator of an imminent ransomware encryption event.

**Phase 2 — EDR Detection Policy Deployment**  
The `edr_policy.xml` template was opened and reviewed. The critical element was a `<CommandLine condition="contains">delete shadows</CommandLine>` filter inside the `<ProcessCreate>` block — an XML rule telling Sysmon to generate an alert when any process creation event contains the string `delete shadows` in its command line arguments. `sudo sysmon -c ~/edr_policy.xml` loaded the new configuration into the running Sysmon instance without restarting it. Re-running the script and filtering the syslog for `delete shadows` confirmed the custom rule fired — producing a targeted, low-noise alert for exactly the ransomware precursor behavior rather than logging every process creation indiscriminately.

### Tools & Commands Used

- `curl -sL <url> | tr -d '\r' | sudo bash` — installed SysmonForLinux, PowerShell Core, and the simulated ransomware environment
- `sudo sysmon -accepteula -i` — accepted the EULA and initialized Sysmon with default configuration
- `pwsh ~/invoice_macro.ps1` — executed the obfuscated script using PowerShell Core
- `sudo tail -n 50 /var/log/syslog | grep -i sysmon` — inspected Sysmon Event ID 1 logs to discover the script's actual child process and command line
- `nano ~/edr_policy.xml` — reviewed and confirmed the XML detection policy
- `<CommandLine condition="contains">delete shadows</CommandLine>` — the targeted detection rule inside the `<ProcessCreate>` block
- `sudo sysmon -c ~/edr_policy.xml` — loaded the custom XML policy into the running Sysmon instance
- `pwsh ~/invoice_macro.ps1` — re-executed the script to trigger the custom rule
- `sudo tail -n 20 /var/log/syslog | grep -i "delete shadows"` — verified the targeted alert fired
- `cat ~/edr_policy.xml` — verified the artifact before submission
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`edr_policy.xml` — A Sysmon XML detection policy containing a `ProcessCreate` rule that fires a targeted alert when any process command line contains the string `delete shadows` — detecting the canonical ransomware shadow copy deletion precursor before encryption begins.

---

## Key Concepts

**Sysmon Event ID Reference**

| Event ID | Event Type | What it captures |
|---|---|---|
| 1 | Process Creation | Command line, parent PID, user, hashes |
| 3 | Network Connection | Outbound TCP/UDP connections from processes |
| 7 | Image Loaded | DLLs loaded by processes |
| 11 | File Created | New files written to disk |
| 13 | Registry Value Set | Registry modifications |
| 22 | DNS Query | Domain name lookups by processes |

Event ID 1 is the highest-value event for malware detection because it captures the full command line — including any arguments — for every process that starts on the endpoint.

**Sysmon XML Policy Structure**

```xml
<Sysmon schemaversion="4.22">
  <EventFiltering>
    <RuleGroup name="" groupRelation="or">
      <ProcessCreate onmatch="include">
        <CommandLine condition="contains">delete shadows</CommandLine>
      </ProcessCreate>
    </RuleGroup>
  </EventFiltering>
</Sysmon>
```

`onmatch="include"` means: only log events where at least one condition matches. `onmatch="exclude"` means: log everything except matching events. The `condition` attribute supports: `contains`, `is`, `begin with`, `end with`, `image`, `less than`, `more than`.

**Why Shadow Copy Deletion is a High-Confidence Indicator**  
`vssadmin delete shadows /all /quiet` has essentially no legitimate administrative use in a corporate environment. Backup software uses the VSS API directly; administrators rarely run this command manually; and the `/quiet` flag (suppress all prompts) is a strong indicator of automated execution rather than human input. In a production SOC, a Sysmon alert on this command line would immediately trigger an automated response — isolating the endpoint from the network before encryption could begin.

**Network IDS vs. Host EDR — Complementary Layers**

```
Network IDS (Suricata — S32)
  └── Sees: traffic between hosts
  └── Blind to: encrypted traffic, local-only activity

Host EDR (Sysmon — S33)
  └── Sees: every process, command, file, registry change on the endpoint
  └── Blind to: network traffic that never touches the monitored host
```

Together, network IDS and host EDR provide visibility at every layer of the kill chain.

---

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5
