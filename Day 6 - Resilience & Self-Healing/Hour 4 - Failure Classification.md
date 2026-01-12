# 🔥 Day 6 — Hour 4

## Failure Classification: Automation vs Human Judgment

> This hour is about **thinking like an SRE**, not running commands.
> The goal is to prevent **dangerous automation** by clearly defining what Docker restart policies *should* and *should not* handle.

---

## 1️⃣ Objective of Hour 4

The objective of this hour was to answer one core question:

> **When is it safe to let Docker auto-restart a container, and when is it dangerous?**

By the end of this hour, the goal was to be able to confidently say:

> “I know auto-restart boundaries — which failures are safe to automate and which must always involve a human.”

This hour is the **decision layer** that sits on top of everything learned in Hours 1–3.

---

## 2️⃣ Core Principle (Non‑Negotiable)

Docker restart policies answer **only one question**:

> “Should this container be started again?”

They do **not** answer:

* Is the application correct?
* Will restarting fix the problem?
* Is the system in a safe state?

Those decisions belong to **humans and system design**, not Docker.

---

## 3️⃣ The Master Rule for Failure Classification

> **Auto‑restart is safe only when the system is still fundamentally correct.**

Everything in this hour reduces to identifying whether a failure is:

* **Transient** vs **Deterministic**
* **External** vs **Internal**

---

## 4️⃣ Auto‑Recoverable Failures (Restart = Reasonable)

These failures are safe for Docker restart policies because restarting can realistically lead to recovery.

### ✅ Characteristics

* Temporary
* Non-deterministic
* External to the application’s core logic
* The system eventually becomes healthy again

### ✅ Examples (Proven Safe)

* Application process crashes due to a transient bug
* Temporary database downtime (DB restarting)
* Brief network outages
* Temporary traffic spikes
* Docker daemon restart
* Host VM reboot

### Why Restart Works Here

Restarting gives the system **another chance** once the external condition has resolved.

> Failure happened *to* the app, not *because of* the app.

---

## 5️⃣ NOT Auto‑Recoverable Failures (Restart = Dangerous)

These failures must **never** be blindly auto-restarted.

### ❌ Characteristics

* Deterministic
* Repeatable
* Caused by code, configuration, or data
* Restarting produces the same failure every time

### ❌ Examples (Proven Dangerous)

* Missing or incorrect environment variables
* Invalid configuration values
* Database schema mismatch
* Broken Docker image (wrong CMD / missing binary)
* Logic bugs causing CPU spikes or OOM kills
* Application exits immediately on startup every time

### Why Restart Is Dangerous Here

* Creates infinite restart loops
* Wastes CPU and memory
* Pollutes logs
* Masks real deployment failures
* Can falsely signal system health

> Restarting does **not** change the cause — it only repeats the failure.

---

## 6️⃣ Subtle but Critical Case: OOM Kills

An OOM kill looks like a **crash** from Docker’s perspective.

But classification depends on **why** it happened:

* ❌ Logic bug causing memory leak → NOT auto‑recoverable
* ✅ Temporary load spike → auto‑recoverable

This reinforces the rule:

> Docker sees *symptoms*. Humans must understand *causes*.

---

## 7️⃣ Host‑Level Failures vs App‑Level Failures

### Host‑Level (Safe to Auto‑Recover)

* Docker daemon restart
* VM reboot
* Cloud maintenance
* Kernel restart

Why?

> The application itself was healthy.

Restarting simply restores the runtime environment.

---

### App‑Level (Often Unsafe to Auto‑Recover)

* Broken builds
* Bad configs
* Code/data contract violations

Why?

> The system is fundamentally incorrect.

Automation hides the problem instead of fixing it.

---

## 8️⃣ Failure Classification Summary Table

| Failure Type                | Auto‑Recoverable | Reason                             |
| --------------------------- | ---------------- | ---------------------------------- |
| Transient app crash         | ✅ Yes            | Process died, system still correct |
| Temporary DB/network outage | ✅ Yes            | External dependency recovers       |
| Temporary traffic spike     | ✅ Yes            | Load normalizes                    |
| Docker daemon restart       | ✅ Yes            | Platform failure only              |
| VM reboot                   | ✅ Yes            | Host failure only                  |
| Missing env vars            | ❌ No             | Deterministic config failure       |
| Schema mismatch             | ❌ No             | Code/data contract broken          |
| Logic bug (CPU/OOM loop)    | ❌ No             | Failure repeats every restart      |
| Broken image / CMD          | ❌ No             | Build-time defect                  |

---

## 9️⃣ Why Hour 4 Is Critical for Production

Without failure classification:

* `restart: always` becomes dangerous
* outages get hidden
* systems appear "up" but are broken

With failure classification:

* restart policies are intentional
* automation is controlled
* humans intervene only when required

This hour defines the **boundary between automation and responsibility**.

---

## 🔟 Hour‑4 Final Takeaway

> **Automation is powerful only when its limits are understood.**

Docker restart policies are tools — not intelligence.

Reliability comes from:

* correct system design
* correct failure classification
* disciplined use of automation

Hour 4 is **fully complete**.
