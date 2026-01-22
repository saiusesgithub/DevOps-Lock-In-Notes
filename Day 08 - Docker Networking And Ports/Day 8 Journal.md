# CODING JOURNAL 

📅 **Day 8 — Docker Networking & Ports**

**Environment:** Local machine (Docker Engine), terminal-only, Docker CLI, Docker Compose

## ✅ What I Did

Started the day by explicitly locking the **Docker networking mental model** before running any commands
Reasoned about containers as isolated network namespaces rather than “apps with ports”
Clearly separated the three traffic directions: **host → container**, **container → container**, and **container → host (rare)**

Built a real long-running Python HTTP server instead of using hello-world
Confirmed that a container appearing “stuck” in the terminal is expected behavior for foreground services
Observed that `docker ps` showing `PORTS 3000/tcp` does **not** mean the host can reach the service

Ran the container **without port mapping** and verified the service was unreachable from the host
Added correct port mapping (`-p host:container`) and confirmed host access worked immediately
Experimented with port remapping and verified that Docker blindly forwards traffic to the specified internal port

Intentionally broke host access by:

* Mapping the wrong internal port
* Curling the wrong host port
* Relying on `EXPOSE` without `-p`

Verified that `EXPOSE` is documentation only and does not create any network bridge
Locked the concept that **port mappings are explicit translation bridges, not automatic exposure**

Discovered and debugged the most critical networking failure:

* Bound the server to `127.0.0.1`
* Observed container running but unreachable from host
* Fixed by rebinding the service to `0.0.0.0`

Proved that loopback addresses are **namespace-local** and do not receive traffic forwarded by Docker

Moved to **container ↔ container networking** using a user-defined Docker network
Created a shared bridge network and attached multiple containers manually

Encountered a real DNS failure due to **network name mismatch**
Learned that Docker DNS resolution is **strictly scoped to the same network** and exact names matter

Confirmed that container-to-container communication works using **container/service names**, not IPs
Verified that `localhost` always fails between containers because it never crosses namespaces

Observed real-world readiness timing:

* First request failed
* Second request succeeded
* Learned that process start ≠ service readiness

Rebuilt the entire system using **Docker Compose**, deliberately slowing down to avoid abstraction confusion
Started from a clean directory and rebuilt server, Dockerfile, and image from scratch

Validated the container manually before introducing Compose to maintain confidence
Introduced Docker Compose incrementally:

* Minimal `docker-compose.yml`
* Observed automatic network creation
* Inspected the Compose-created network

Added `ports:` in Compose and verified it affected **host access only**
Added a client service to prove internal DNS and service-name resolution

Observed Compose lifecycle behavior:

* Client exited with code `0` after success
* Server exited with code `137` due to Compose teardown
* Confirmed this was expected behavior, not a crash

Concluded the day by consolidating **failure cases** instead of adding new features
Converted each observed mistake into a predictable diagnostic pattern

## 🧠 What I Learned

Docker networking is not complex — it is misunderstood due to missing mental models
Each container is effectively its own machine with its own network namespace

Ports do not expose services; they **translate traffic** between host and container
A running container does not imply a reachable service

`EXPOSE` communicates intent but performs no networking action
Explicit port mapping is always required for host access

Binding matters more than mapping
Binding to `127.0.0.1` silently breaks both host → container and container → container traffic

Internal Docker networking is simpler than host networking
Containers on the same network communicate directly using names and internal ports

Docker DNS is network-scoped and deterministic
Service names resolve only within the same Docker network

`localhost` is always local to the current namespace and is a common source of bugs

Startup order does not guarantee readiness
Real systems require retries, health checks, or explicit waiting

Docker Compose does not introduce new networking rules
It automates network creation, DNS registration, and container attachment

Exit codes must be interpreted in context
A container exiting does not imply failure if it was intentionally stopped

The most reliable debugging approach is:

* Identify traffic direction
* Verify binding
* Verify network membership
* Verify port translation (only if host is involved)

**Status:** ✅ I can reason about Docker networking without relying on trial-and-error
**Result:** ✅ Ports, networks, and service discovery now feel mechanical, predictable, and non-magical
