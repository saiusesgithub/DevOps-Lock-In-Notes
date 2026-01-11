# Day 5 — Deployment & Continuous Delivery (CD)

## 1. What Deployment Actually Means

Deployment is the act of **taking a built artifact** and **running it in an environment where users depend on it**.

Key idea:

* **CI answers:** *Does this build and behave correctly in isolation?*
* **Deployment answers:** *Does this stay alive, recover, and remain observable over time?*

Deployment begins **after CI succeeds**.

---

## 2. CI vs CD (Hard Boundary)

### Continuous Integration (CI)

* Runs on **ephemeral machines**
* Fresh OS every run
* No state survives
* Purpose:

  * Build artifacts
  * Run tests
  * Enforce repo truth
* Failure mode: ❌ build fails

### Continuous Delivery / Deployment (CD)

* Runs on **long‑lived machines** (VMs, servers)
* State persists across reboots
* Purpose:

  * Keep software running
  * Recover from failure
  * Expose logs & runtime behavior
* Failure mode: 🚨 service downtime

> CI proves correctness once. CD proves reliability over time.

---

## 3. Artifacts: The Contract Between CI and CD

An **artifact** is what CI hands to deployment.

Examples:

* Docker image
* Binary
* JAR file
* Compiled frontend bundle

Rules:

* CI **builds artifacts**
* Deployment **never edits source code**
* Deployment only:

  * Pulls artifacts
  * Runs artifacts
  * Configures runtime

If deployment requires modifying code → CI failed its responsibility.

---

## 4. The Nature of a VM (Why It Matters)

A VM is:

* Stateful
* Long‑lived
* Mutable

It remembers:

* Installed packages
* Running containers
* Files on disk
* Logs

This creates **two dangers**:

1. **Configuration drift**

   * “It works on this VM but not another”
2. **False confidence**

   * Something works only because of leftover state

Deployment discipline exists to **control VM chaos**.

---

## 5. SSH Is Not Deployment

SSH is:

* A remote terminal
* A human access tool

SSH is NOT:

* A process manager
* A reliability mechanism
* A deployment strategy

If an app:

* Stops when SSH closes
* Depends on `screen` / `tmux`

→ It is **not deployed**.

A deployed system must:

* Run without a human attached
* Survive network disconnects

---

## 6. Processes, Containers, and Lifetimes

### Process lifetime rules

* A process lives **only while its parent keeps it alive**
* SSH session ends → foreground processes die

### Container reality

* A container **is just a Linux process**
* Docker does not make it special

Important consequences:

* Containers can crash
* Containers can be killed
* Docker daemon restarts kill containers

Deployment must handle all three.

---

## 7. `docker run` — Necessary but Incomplete

`docker run` answers only one question:

> “Can this artifact start right now?”

It does NOT answer:

* What if it crashes?
* What if Docker restarts?
* What if the VM reboots?
* Where do logs go?

That’s why **deployment is more than a command**.

---

## 8. Logs: The Only Truth

In deployment:

* Logs replace intuition
* Logs replace dashboards
* Logs replace assumptions

Rules:

* If it’s running → it’s logging
* If it’s broken → logs explain why

No logs = blind system

A deployable system must allow you to:

* Read logs
* Correlate failures
* Restart with confidence

---

## 9. Failure Is Mandatory in Deployment

Deployment knowledge comes from **controlled failure**.

You must expect:

* Container crashes
* Misconfigured ports
* Missing environment variables
* Docker daemon restarts
* VM reboots

A system that only works when untouched is **not deployed**.

---

## 10. Manual Deployment (Why It Comes First)

Before automation:

* You must know every moving part
* You must feel the failure
* You must recover manually

Manual deployment teaches:

* What state exists
* What disappears
* What must be recreated

Automation without understanding just hides ignorance.

---

## 11. The Core Deployment Questions

Every deployment must answer:

1. How is the artifact obtained?
2. How is it started?
3. How does it stay running?
4. How is it restarted?
5. Where are logs?
6. What breaks on restart?
7. What breaks on reboot?

If you can’t answer one → deployment incomplete.

---

## 12. What Deployment Is NOT

Deployment is NOT:

* CI pipelines
* One‑click platforms
* Dashboards
* Magic YAML

Deployment IS:

* Linux
* Processes
* Files
* Logs
* Responsibility

---

## 13. End‑State Mental Model

> *A deployed system is a set of processes running on a machine that can crash, restart, and recover without human attachment — and can always explain itself through logs.*

This is the bar for Day 5.

---
