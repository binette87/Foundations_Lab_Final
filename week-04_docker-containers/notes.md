# Week 4 — Virtualization, Hypervisors & Containers
## Session Notes

**Course:** Foundations of Cybersecurity  
**Week:** 4 · Sessions 10, 11 · TLAB-04  
**Topics:** Virtualization & Hypervisors, Forensic Sandbox Configuration, VM Network Isolation

---

## Session 10: The Ghost in the Machine

### Summary

This session introduced virtualization as a foundational security primitive, with a focus on hypervisor architecture and network isolation. The core concept established was that a virtual machine is only as secure as its network boundary — a VM running in Bridged Adapter mode is a full participant on the host's local network, meaning any malware detonated inside it can discover, communicate with, and potentially attack other devices on that same network (NIST, 2020). This misconfiguration is one of the most common and dangerous mistakes in malware analysis lab setup.

The micro-lab addressed this risk directly by reconfiguring the Ubuntu VM's network adapter from Bridged mode to Host-Only mode inside VirtualBox. In Host-Only mode, the VM can communicate with the host machine but has no route to the internet or to any other device on the local network — creating a true digital air gap. This is the foundational step in building a forensic sandbox: a controlled, isolated detonation environment where suspicious files and scripts can be executed safely without risk of lateral movement or external callback.

Phase 2 extended the configuration into active verification. A provisioning script was executed via `curl | sudo bash` to initialize the sandbox environment and generate a forensic report template. The air gap was then validated using `ping -c 4 google.com`. A successful sandbox produces either `Temporary failure in name resolution` or `Network is unreachable` — confirming that the VM cannot resolve external hostnames or route outbound traffic. Any live response (bytes and round-trip times) would indicate a sandbox leak requiring immediate correction.

The session's primary deliverable, `sandbox_report.txt`, was completed inside the Nano text editor directly on the VM. The report documented the ping test result and explained the specific security risk posed by Bridged Adapter mode: because the VM receives a real IP address on the local subnet in Bridged mode, any malware executing inside it has a full network map and can initiate connections to printers, routers, NAS devices, and other computers on the same Wi-Fi — bypassing the isolation the analyst intended.

### Tools & Commands Used

- **VirtualBox / UTM** — accessed VM network settings to change the adapter mode
- **Bridged Adapter → Host-Only Adapter** — changed the network attachment type to enforce air-gap isolation
- `curl -sL <url> | sudo bash` — fetched and executed the provisioning script to initialize the sandbox environment
- `ping -c 4 google.com` — performed the air-gap detonation test; a resolution failure confirmed the sandbox was secure
- `nano ~/sandbox_report.txt` — opened the forensic report template for editing
- `CTRL + O` / `Enter` / `CTRL + X` — saved and exited the Nano editor
- `cat ~/sandbox_report.txt` — verified the completed report before submission
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`sandbox_report.txt` — A structured forensic sandbox report documenting the VM's network isolation status, the result of the air-gap detonation test, and an analysis of the security risk posed by running a malware analysis lab in Bridged Adapter mode.

---

## Key Concepts

**Type 1 vs. Type 2 Hypervisors**  
A Type 1 (bare-metal) hypervisor runs directly on hardware without a host OS — examples include VMware ESXi and Microsoft Hyper-V. A Type 2 (hosted) hypervisor runs on top of a conventional OS — VirtualBox and UTM are Type 2. Security labs for students typically use Type 2 hypervisors because they run on standard laptops and desktops. Enterprise SOC environments more commonly use Type 1 for performance and isolation reasons (NIST, 2020).

**Network Adapter Modes — Security Implications**

| Mode | VM gets IP from | Can reach internet | Can reach LAN devices | Security risk |
|---|---|---|---|---|
| Bridged Adapter | Home router (DHCP) | Yes | Yes | High — malware can attack LAN |
| NAT | VirtualBox internal | Yes (outbound only) | No | Medium — malware can call home |
| Host-Only | VirtualBox host-only network | No | No (host only) | Low — true air gap |
| Internal Network | VirtualBox internal | No | No | Lowest — VM-to-VM only |

**Why `curl | sudo bash` is a risk pattern**  
Piping a remote script directly to a privileged shell executes arbitrary code from the internet without inspection. In a security lab context, this is used intentionally to simulate how malware is deployed. In production environments, this pattern is considered dangerous and should be replaced with verified, signed package installations (NIST, 2020).

---

---

## Session 11: The Container Revolution

### Summary

This session introduced containerization as a modern evolution of virtualization, using Docker as the primary tool. Where a virtual machine emulates an entire hardware stack and runs a full OS kernel, a container shares the host kernel and packages only the application and its dependencies — making containers dramatically faster to start, smaller in size, and easier to replicate (NIST, 2020). The security implications are significant: containers provide process and filesystem isolation through Linux namespaces and control groups (cgroups), but they do not provide the same hardware-level separation as a full VM.

The micro-lab demonstrated this isolation concretely. After pulling the Alpine Linux image (`docker pull alpine`) and launching an interactive shell inside it (`docker run -it alpine sh`), running `ps aux` inside the container revealed only a handful of processes — not the hundreds visible on the host Ubuntu system. This confirmed that the container's process namespace was isolated: it could not see or interact with host processes. Exiting the shell stopped and discarded the container entirely, illustrating the ephemeral nature of containerized workloads.

Phase 2 extended this into a realistic deployment scenario. An Nginx web server container was launched in detached mode (`-d`), named for easy reference (`--name training-web`), and port-mapped so that traffic arriving on host port 8080 was forwarded to container port 80 (`-p 8080:80`). The `docker exec -it` command was used to open an interactive bash shell inside the already-running container, demonstrating that exec differs from run — it attaches to an existing process rather than starting a new one. The default Nginx index page was overwritten using a simple `echo` redirect, proving that container filesystems can be modified at runtime. `docker logs` retrieved the container's stdout/stderr stream, a primary tool for container forensics and incident triage. The container was then fully removed with `docker stop` followed by `docker rm`, and verified absent with `docker ps -a`.

The session culminated in a deployment automation exercise. The `deploy_web.sh` script — seeded by the initialization script — was opened in Nano and populated with the `docker run` command from Phase 2. Running `./deploy_web.sh` reproduced the entire deployment from a single command, demonstrating the principle of infrastructure as code: repeatable, auditable, and version-controlled deployments.

### Tools & Commands Used

- `docker pull alpine` — downloaded the Alpine Linux image from Docker Hub
- `docker run -it alpine sh` — launched an interactive Alpine container with a shell
- `ps aux` — enumerated running processes inside the container; confirmed namespace isolation
- `exit` — exited the shell and stopped the container
- `docker run -d --name training-web -p 8080:80 nginx` — launched an Nginx container in detached mode with port mapping
- `docker exec -it training-web bash` — opened an interactive bash shell inside the running Nginx container
- `echo "Titan Security Training" > /usr/share/nginx/html/index.html` — overwrote the default Nginx web page
- `docker logs training-web` — retrieved the container's stdout/stderr log stream
- `docker stop training-web` — sent SIGTERM to gracefully stop the running container
- `docker rm training-web` — permanently removed the stopped container and its writable layer
- `docker ps -a` — listed all containers (including stopped) to confirm removal
- `nano ~/deploy_web.sh` — edited the deployment automation script
- `./deploy_web.sh` — executed the script to test the full automated deployment
- `git add`, `git commit`, `git push` — committed the artifact to the GitHub portfolio

### Artifact

`deploy_web.sh` — A shell script that automates the deployment of a disposable Nginx web server container with port mapping, demonstrating repeatable, code-driven infrastructure provisioning.

---

## Key Concepts

**VMs vs. Containers**

| | Virtual Machine | Container |
|---|---|---|
| Kernel | Own full OS kernel | Shares host kernel |
| Startup time | Minutes | Seconds |
| Image size | GBs | MBs |
| Isolation level | Hardware-level (hypervisor) | OS-level (namespaces + cgroups) |
| Security boundary | Strong | Weaker — kernel escape is a known attack class |

**Docker Port Mapping (`-p host:container`)**  
The `-p 8080:80` flag instructs Docker to listen on host port 8080 and forward all traffic to port 80 inside the container. This means the host does not need Nginx installed at all — the service exists entirely within the container's isolated network namespace.

**`docker run` vs. `docker exec`**  
`docker run` creates and starts a brand-new container from an image. `docker exec` attaches a new process to a container that is already running. Using `exec` for post-deployment investigation is a core container forensics technique.

**Why `curl | sudo bash` is a risk pattern**  
Piping a remote script directly to a privileged shell executes arbitrary code from the internet without inspection. In a security lab this is intentional — simulating how malware and attack toolkits are deployed. In production, this pattern should be replaced with verified, signed package installations.

---

## References

National Institute of Standards and Technology. (2020). *Security and privacy controls for information systems and organizations* (NIST Special Publication 800-53, Rev. 5). U.S. Department of Commerce. https://doi.org/10.6028/NIST.SP.800-53r5
