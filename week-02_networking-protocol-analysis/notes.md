# Week 2 — Networking & Protocol Analysis
## Session Notes

**Course:** Foundations of Cybersecurity  
**Week:** 2 · Sessions 4, 5, 6 · TLAB-02  
**Topics:** Network Interface Restoration, IP Subnetting & CIDR, DNS & Protocol Interrogation

---

## Session 04: The Invisible Architecture

### Summary

This session introduced the OSI model as an operational framework for diagnosing and restoring network connectivity. The lab simulated a remote intercept station with a completely severed network connection, requiring systematic layer-by-layer troubleshooting from the Physical and Data Link layers upward. Understanding the OSI model is foundational to network security, as identifying which layer a failure occurs at determines the appropriate remediation strategy (NIST, 2020).

In Phase 1, connectivity was confirmed as absent using `ping`, and the network interface was identified via `ip link` as being in a `DOWN` state. The interface was brought up using `sudo ip link set`. In Phase 2, the presence of an IP address was verified with `ip addr`, and `ip route` was used to identify a missing default gateway route, which was then manually added. Finally, `traceroute` was used to verify the restored outbound path. The audit state of the restored network was captured and saved as the session artifact.

### Tools & Commands Used

- `ping` — tested end-to-end connectivity to verify the network was unreachable
- `ip link` — inspected network interface state and identified the downed interface
- `sudo ip link set` — brought the network interface up from a `DOWN` state
- `ip addr` — verified IP address assignment on the restored interface
- `ip route` — audited and diagnosed the missing default gateway route
- `sudo ip route add` — manually restored the default gateway route
- `traceroute` — traced the packet path to confirm outbound connectivity was restored
- Output redirection (`>`) — captured the final route table to `network_audit.txt`
- `git add`, `git commit`, `git push` — committed and pushed the artifact to the GitHub portfolio

### Artifact

`network_audit.txt` — A captured snapshot of the restored IP routing table, documenting the successfully re-established network path after interface and gateway remediation.

---

## Session 05: The Subnetting Crucible

### Summary

This session provided hands-on application of IP subnetting, CIDR notation, and binary network mathematics to diagnose and resolve a subnet misconfiguration that was isolating a host from its gateway. Subnetting is a critical network security skill, as misconfigured subnet masks can render hosts unreachable and serve as a vector for network isolation attacks (NIST, 2020).

The lab began with binary interrogation, converting an IP address octet to binary using Python to understand why the current `/26` mask excluded the gateway address. The `ipcalc` tool was then used to calculate the precise host range, confirming that the gateway (`10.50.50.1`) fell outside the usable range. The fix required deleting the restrictive `/26` assignment and re-adding the IP with a `/24` mask, which expanded the host range to include the gateway. A successful `ping` to the gateway confirmed resolution. The final artifact captured the `ipcalc` output for both the corrected `/24` and a reference `/27` subnet for comparative analysis.

### Tools & Commands Used

- `ip addr` — verified the current IP address and subnet mask assignment
- `python3` / `bin()` — converted IP octets to binary to analyze subnet boundaries
- `ipcalc` — calculated host ranges, network IDs, and broadcast addresses for CIDR subnets
- `sudo ip addr del` — removed the restrictive `/26` subnet assignment
- `sudo ip addr add` — re-assigned the IP address with the corrected `/24` mask
- `ping` — verified gateway reachability after the subnet correction
- Append redirection (`>>`) — captured `ipcalc` output for both subnets into `subnet_blueprint.txt`
- `git add`, `git commit`, `git push` — committed and pushed the artifact to the GitHub portfolio

### Artifact

`subnet_blueprint.txt` — A documented CIDR analysis containing `ipcalc` output for the corrected `/24` network and a `/27` reference subnet, demonstrating applied subnetting calculations.

---

## Session 06: Protocol Interrogation

### Summary

This session explored DNS resolution and port-level service discovery as applied to detecting network deception and hidden services. The scenario involved two adversarial conditions: a poisoned `/etc/hosts` file redirecting `google.com` to a local Nginx server, and a hidden web service listening on a non-standard port. Both represent realistic attack techniques — DNS hijacking and service concealment — used by threat actors to redirect traffic or obscure malicious activity (NIST, 2020).

In Phase 1, `curl -I` was used to inspect HTTP response headers, revealing that queries to `google.com` were being served by a local Nginx instance rather than Google's infrastructure. The `/etc/hosts` file was audited and the malicious redirect entry was removed. The `dig` command then confirmed resolution of legitimate public IPs. In Phase 2, `ss -tuln` was used to enumerate all listening sockets, revealing a hidden service on a non-standard port. `curl -I` was then used to identify the service from its response headers. All three outputs were captured as the session artifact.

### Tools & Commands Used

- `curl -I` — sent HTTP HEAD requests to inspect server response headers for deception indicators
- `cat /etc/hosts` — audited local DNS override entries for malicious redirects
- `sudo nano /etc/hosts` — removed the adversarial entry pointing `google.com` to `127.0.0.1`
- `dig` — verified DNS resolution was returning legitimate public IP addresses post-remediation
- `ss -tuln` — enumerated all TCP/UDP listening sockets to identify the hidden service port
- Append redirection (`>>`) — captured `dig`, `curl`, and `ss` outputs into `protocol_audit.txt`
- `git add`, `git commit`, `git push` — committed and pushed the artifact to the GitHub portfolio

### Artifact

`protocol_audit.txt` — A forensic audit document containing DNS resolution output, HTTP server header evidence, and a full socket enumeration, collectively proving the detection and remediation of both network deception techniques.

---

## TLAB-02: Operation Blackout

### Summary

Operation Blackout was a 90-minute unguided remediation mission synthesizing all three Week 2 skills under adversarial conditions. The scenario simulated a sophisticated actor who had sabotaged the network at multiple OSI layers simultaneously: a restrictive `/26` subnet mask isolating the host from its gateway (Layer 3), a poisoned `/etc/hosts` file redirecting `secure.titancorp.com` to a malicious IP (Layer 7), and a requirement to prove full TCP connectivity restoration via a captured 3-way handshake (Layer 4). The session was intentionally designed to drop the primary SSH connection upon setup, requiring use of an Out-of-Band (OOB) web console for recovery — a technique used in real-world infrastructure incident response (NIST, 2020).

In Task 1, `ipcalc` was used to confirm the subnet boundary, and the host was re-addressed from `/26` to `/24` with the default gateway manually restored. In Task 2, `/etc/hosts` was inspected and the malicious entry for `secure.titancorp.com` was removed, with `dig` confirming correct resolution to `192.168.10.193`. In Task 3, `tcpdump` was used to capture live packet traffic while `curl` initiated a connection, producing forensic evidence of the TCP 3-way handshake (SYN, SYN-ACK, ACK flags) confirming full stack restoration.

### Tools & Commands Used

- `ipcalc` — verified the adversarial `/26` subnet boundary and calculated the corrected `/24` range
- `sudo ip addr del` / `sudo ip addr add` — re-addressed the interface with the correct subnet mask
- `sudo ip route add` — restored the default gateway route to `192.168.10.1`
- `ip route` — confirmed the gateway route was successfully restored
- `cat /etc/hosts` — identified the malicious DNS entry redirecting `secure.titancorp.com`
- `sudo nano /etc/hosts` — removed the adversarial redirect entry
- `dig` — confirmed `secure.titancorp.com` resolved to the correct internal target
- `tcpdump` — captured live network traffic to record the TCP 3-way handshake as forensic proof
- `curl` — triggered the HTTP request to generate the handshake evidence
- `git add`, `git commit`, `git push` — committed and pushed the artifact to the GitHub portfolio

### Artifact

`tlab_report.txt` — A forensic remediation report containing the restored IP route table and a `tcpdump` snippet showing the TCP 3-way handshake (SYN → SYN-ACK → ACK), serving as forensic proof of full network stack restoration following a multi-layer sabotage event.

---

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5
