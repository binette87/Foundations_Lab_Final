# Week 11 — Active Defense
## Session Notes

**Course:** Foundations of Cybersecurity  
**Week:** 11 · Session 31 · TLAB-11  
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

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5
