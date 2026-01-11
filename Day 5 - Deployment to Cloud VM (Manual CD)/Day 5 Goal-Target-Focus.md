# 📅 Day 5 — Deployment to Cloud VM (Manual CD)

**Date:** January 11  
**Focus:** Manual Continuous Deployment (CD), long-lived systems, runtime failures, recovery, operational confidence  
**Environment:** Ubuntu EC2 (cloud VM), Docker Engine, terminal-only (no dashboards, no automation)

---

## 🎯 Objective for the Day

The goal for Day 5 was **not** to learn cloud services, EC2 UI, or one-click deployment tools.

The real objective was to move from:

> *“My app builds successfully”*  
> to  
> *“My app stays alive, breaks, and can be recovered on a real server.”*

By the end of the day:

* Deployment should feel like **owning a machine**, not running a command
* Containers should feel like **Linux processes**, not magic units
* Failures should feel **inevitable, explainable, and recoverable**
* Confidence should come from **manual recovery**, not hope or automation

If the app only worked locally or only in CI, **Day 5 would be considered a failure**.

---

## 🧠 Mental Models Established

Before touching deployment commands, these foundations were locked.

### CI Builds Artifacts, CD Runs Artifacts

* **CI** → builds and validates artifacts
* **CD** → runs artifacts on long-lived machines

Deployment is not about correctness once —  
it is about **survival over time**.

---

### VM = Long-Lived, Stateful Machine

* Unlike CI runners:
  * VMs remember disk state
  * Processes die, disk remains
* Memory resets on reboot
* Runtime state must be reconstructed deliberately

This introduced **real operational responsibility**.

---

### SSH ≠ Deployment

* SSH is just a remote terminal
* Closing SSH must **not** stop the app
* If the app dies when SSH disconnects → it is not deployed

This killed the illusion of “it’s running because I see it”.

---

### Containers Are Processes

* A container lives **only as long as its main process**
* `docker run -d` does not mean “keep alive”
* Exit code `0` can still mean **service stopped**

This corrected a common misunderstanding early.

---

## 🧱 Hour 1 — Deployment Mental Model (No Execution)

Before touching the VM, the focus was on:

* CI vs CD boundary
* Runtime vs disk state
* Why deployment failures are harsher than CI failures
* Why logs replace intuition

This prevented premature fixing and blind command execution later.

---

## 🧱 Hour 2 — Preparing the Cloud VM

Actions performed:

* SSH into Ubuntu EC2
* Verified Docker installation
* Verified Docker daemon status
* Ensured Docker starts on boot
* Fixed Docker permissions using **Linux groups** (removed `sudo docker` dependency)

Key realization:

> A VM must be *operationally usable* before it can be a deployment target.

This was intentional **manual CD**, not automation.

---

## 🧱 Hour 3 — Manual Deployment to the VM

Core deployment work:

* Cloned GitHub repo directly onto the VM
* Inspected Dockerfile and runtime script
* Built Docker image **on the VM**
* Ran container in detached mode
* Observed container exiting immediately
* Used logs to understand why
* Modified runtime behavior to create a **long-lived process**
* Verified container survives SSH disconnect

Key lesson:

> Deployment begins when the terminal becomes irrelevant.

This was the moment the VM became a **server**, not a playground.

---

## 📜 Hour 4 — Logs & Runtime Debugging

Focus shifted from running → **observing**.

Practiced:

* Reading historical logs (`docker logs`)
* Streaming live logs (`docker logs -f`)
* Differentiating:
  * Process death
  * Container exit
  * Docker daemon behavior

### Intentional Runtime Failure

* Killed the container (`docker kill`)
* Observed exit code `137`
* Confirmed:
  * Docker daemon alive
  * Container definition intact
  * Process dead

Recovered manually using:

* `docker start`
* Log verification

This proved logs are the **first and only truth** during failures.

---

## 💣 Hour 5 — Failure Day (Mandatory)

This hour simulated **real production-grade failures**.

### Failures Simulated

1. **Process crash**
   * `docker kill`
2. **Docker daemon restart**
   * `systemctl restart docker`
3. **Full VM reboot**
   * `sudo reboot`

### Observations

* Running containers do **not** survive daemon restart
* Runtime memory does **not** survive VM reboot
* Disk state (images, containers, repo) **does** survive

Recovered manually after each failure using:

* `docker start`
* Logs for verification

Key truth locked:

> Docker provides configuration persistence by default — not uptime.

---

## 🔁 Hour 6 — Rebuild From Memory (Final Test)

Without notes or command history:

* Opened fresh terminal
* Re-SSH’d into the VM
* Inspected system state calmly
* Removed containers and images intentionally
* Rebuilt image from disk
* Redeployed container
* Verified logs and runtime
* Injected multiple failures
* Recovered cleanly each time

This proved **reasoning**, not memorization.

---

## 🔑 Key Lessons Locked In

* Deployment is about **runtime ownership**
* Containers are not services by default
* Logs precede fixes
* Reboots erase memory, not disk
* Recovery skills matter more than setup skills
* Manual CD must be mastered before automation
* Rebuild-from-memory is the real test

---

## 📝 End-of-Day Reflection

By the end of Day 5, I can confidently say:

> I can deploy a Dockerized app to a cloud VM, understand exactly what is running and why, observe failures using logs, recover from crashes, Docker restarts, and full VM reboots, and rebuild runtime state from disk without guidance or automation.

**Day 5 was completed successfully.**
