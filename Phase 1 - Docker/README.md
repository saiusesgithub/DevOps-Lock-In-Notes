# DevOps Lock-In — Phase 1: Docker & Systems Foundations

## Backstory / Why This Repo Exists
This repository documents a focused, high-intensity "DevOps Lock-In" learning sprint. The motivation was simple: to move beyond tutorial hell and shallow copy-pasting into deep, first-principles engineering.

The entire phase was executed under strict rules:
*   **Terminal-only**: No GUIs, no Docker Desktop, no Portainer.
*   **No shortcuts**: Every configuration was written from scratch.
*   **Rebuild-from-memory**: Learning was validated by deleting everything and rebuilding it without notes.
*   **Failure-first**: Systems were intentionally broken to learn how to fix them.
*   **Reasoning over memorization**: The goal was to understand *why* things work, not just *how* to run them.

## How This Repo Is Organized
The repository is structured into day-wise folders, each representing a distinct step in the learning journey.
*   **Day Folders (`Day 1` - `Day 10`)**: contain the specific notes, experiments, reflection journals, and code artifacts for that day.
*   **Mental Models**: Each folder documents the core concepts locked in during that session.
*   **Experiments**: Evidence of "break-fix" cycles where concepts were tested.

## What I Learned — Day by Day

### Day 1 — Linux & SSH Foundations
*   Mastered terminal navigation, file management, and permissions (`chmod`, `chown`) on a real Ubuntu EC2 instance.
*   Understood the difference between files, running processes, and system services (`systemd`).
*   Learned to treat logs as the primary source of truth for debugging (`journalctl`, `tail -f`).
*   Practiced safe remote server management via SSH without GUI tools.

### Day 2 — Docker Core
*   Demystified Docker by building images and running containers manually.
*   Locked in the distinction between **Build Time** (`RUN`) and **Run Time** (`CMD`/`ENTRYPOINT`).
*   Understood that an Image is a readonly blueprint, while a Container is a writable runtime instance.
*   Debugged build failures and runtime crashes by inspecting logs and exit codes.

### Day 3 — Docker Compose & Systems Thinking
*   Moved from running isolated containers to orchestrating multi-container systems.
*   Learned that `depends_on` controls startup order but **does not guarantee readiness**.
*   Understood creating systems where services communicate via internal DNS service names.
*   Mastered configuration management using Environment Variables (`ENV`) to change behavior without rebuilding images.

### Day 4 — CI/CD Fundamentals
*   Shifted from manual execution to automated verification using GitHub Actions.
*   Internalized that **CI is just a fresh Linux machine** running commands automatically.
*   Learned to trust the pipeline as the single source of truth, not local "it works on my machine" results.
*   Practiced failure-driven development: deliberately breaking pipelines to understand error signals.

### Day 5 — Deployment to Cloud VM (Manual CD)
*   Transitioned from CI artifacts to long-lived deployments on a cloud server.
*   Understood that deployment is about **runtime ownership**, not just running a command.
*   Learned that SSH is an access tool, not a process manager (containers must survive SSH disconnects).
*   Recovered manually from process crashes, daemon restarts, and full VM reboots.

### Day 6 — Resilience & Self-Healing
*   Explored Docker's restart policies (`always`, `on-failure`, `unless-stopped`).
*   Learned that **self-healing is mechanical**, not intelligent—it reacts to exit codes, not logic bugs.
*   Classified failures into transient (recoverable) vs. permanent (config/logic errors).
*   Understood that crash loops are signals that require human intervention/design changes.

### Day 7 — End-To-End Rebuild
*   **The Ultimate Test**: Wiped the entire system (VM, Docker, Repos) and rebuilt it from scratch without notes.
*   Validated deep understanding of the entire stack: Linux -> Docker -> App -> CI -> CD -> Resilience.
*   Proved ownership of the stack by systematically recovering from a zero-state.
*   Solidified Git authentication flows (SSH keys vs HTTPS) on headless servers.

### Day 8 — Docker Networking & Ports
*   Demystified Docker networking: Containers run in isolated network namespaces.
*   Learned that **Ports are bridges** for Host ↔ Container traffic, not for Container ↔ Container communication.
*   Internalized that `localhost` inside a container refers to the container itself, not the host.
*   Experimented with custom bridge networks and service discovery via internal DNS.

### Day 9 — Docker Compose & System Integration
*   Drilled Docker Compose mechanics until they felt boring and predictable.
*   Clarified the boundary between **CI (Build/Verify)** and **Runtime (Compose/Run)**.
*   Practiced "Break-Fix" cycles: intentionally misconfiguring networks, names, and ports to observe exact failure modes.
*   Solidified the mental model that Compose maps logical services to runtime containers.

### Day 10 — Docker Volumes & Persistence
*   Addressed the ephemeral nature of containers and the need for persistent storage.
*   Learned the difference between **Named Volumes** (Docker-managed) and **Bind Mounts** (Host-managed).
*   Proved that **Data Lifecycle ≠ Container Lifecycle**: Data survives container deletion if correct volume strategies are used.
*   Validated persistence by destroying and recreating containers and verifying data integrity.

## Key DevOps Mental Models Gained

*   **CI ≠ CD**: CI is about verification and correctness (fresh machine every time). CD is about availability and runtime state (long-lived).
*   **Containers are Processes**: They are not magic black boxes; they are just isolated Linux processes.
*   **Images are Immutable**: Build once, run anywhere. Configuration changes happen at runtime, not build time.
*   **Volumes are the Persistence Boundary**: Containers are disposable; volumes are where the data/state lives.
*   **Ports are Bridges, Not Exposure**: Publishing a port explicitly bridges the Host network to the Container network.
*   **Restart Policies are Reactions, Not Fixes**: Automation can restart a process, but it cannot fix a logic bug.
*   **Logs are the Source of Truth**: Dashboards lie or lag; logs tell you exactly what the process is doing right now.
*   **Depends_on ≠ Readiness**: Just because a dependency started doesn't mean it's ready to accept connections.
*   **Localhost is Relative**: `localhost` means "this computer". Inside a container, "this computer" is the container, not the host.

## What This Phase Is — And Is NOT
*   **IS**: A deep dive into foundations. Correctness over speed. Understanding over tooling.
*   **IS NOT**: A Kubernetes guide. A quick-start tutorial. A comprehensive list of Docker commands.
*   **IS NOT**: About using "magic" tools that hide complexity.

## How to Use This Repo
*   **For Learning**: Follow the days sequentially. Read the mental models first, then attempt the hands-on tasks.
*   **For Revision**: Review the "Goal-Target-Focus" files in each day to refresh core concepts.
*   **For Interview Prep**: The "Key Mental Models" and failure scenarios are excellent high-level system design talking points.
*   **For Future Phases**: This foundation is required before moving to orchestration (Kubernetes) or advanced CI/CD.

## Phase Status
**Phase 1: COMPLETE**
*   Scope: Docker, Linux, CI Basics, Compose, Networking, Volumes, manual CD.
*   Outcome: Full confidence in building, deploying, and debugging containerized applications.

## What Comes Next
Phase 2 will move beyond single-node Docker basics into:
*   Orchestration and Scaling.
*   Cloud-native patterns.
*   Deeper CI/CD pipelines (Automated CD).
*   Monitoring and Observability stacks.