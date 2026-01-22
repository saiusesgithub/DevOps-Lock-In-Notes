# 🧠 Day 6 — Hour 1

## Resilience, Failure & Self‑Healing — Deep Reference Notes

> These notes are **intentionally over‑detailed**. This is not Day‑6‑only content — this is a **long‑term mental reference** for DevOps, SRE, and production thinking.

---

## 1. Why Resilience Exists (The Real Problem It Solves)

In real systems:

* Hardware fails
* Processes crash
* Memory leaks happen
* Networks flap
* Humans make mistakes

**Failure is not an exception. It is the default state of complex systems.**

Resilience exists because:

* Manual recovery does not scale
* Humans are slow, error‑prone, and unavailable
* Systems fail at 3 AM, not during demos

> Resilience is about **time to recovery**, not absence of failure.

---

## 2. Core Definitions (Lock These Precisely)

### Failure

A deviation from expected behavior.

Examples:

* Process exits
* Service stops responding
* Host reboots unexpectedly

### Recovery

The act of returning to an acceptable operational state.

### Resilience

The system’s ability to **recover automatically and predictably** from failure.

### Self‑Healing

A **mechanical automation** that reacts to predefined failure signals.

> Self‑healing is not intelligence. It is **rule‑based reaction**.

---

## 3. Deployment vs Availability (Expanded View)

### Deployment

* Discrete event
* Happens once per release
* Validated by “it started”

### Availability

* Continuous property
* Validated over hours/days/weeks
* Defined by survival, not startup

| Question                     | Deployment | Availability |
| ---------------------------- | ---------- | ------------ |
| Does it start?               | ✅          | ❌            |
| Does it restart after crash? | ❌          | ✅            |
| Does it survive reboot?      | ❌          | ✅            |
| Does it recover unattended?  | ❌          | ✅            |

> A system that requires SSH is **human‑dependent**, not resilient.

---

## 4. Restart Is a Primitive, Not a Cure

Restarting means:

* Same binary
* Same image
* Same configuration
* Same environment

Therefore restart **amplifies design quality**:

* Good design → restart helps
* Bad design → restart exposes instability

Common misconceptions:

* “Restart will fix it” ❌
* “Just auto‑restart everything” ❌

> Restart reveals problems — it does not remove them.

---

## 5. Failure Layers (Critical Mental Model)

Failures propagate **vertically across layers**.

### Application Layer

* Logic bugs
* Unhandled exceptions
* Deadlocks

### Process Layer

* SIGTERM / SIGKILL
* Out‑of‑memory kill
* Crash exits

### Container Runtime Layer

* Docker daemon restart
* Runtime crash

### Host Layer

* VM reboot
* Kernel panic

### Infrastructure Layer (Outside Docker)

* Network outages
* Disk failure
* Cloud provider issues

Docker restart policies only act on:

* **Process layer**
* **Runtime layer**
* **Host layer**

Everything else requires **design or humans**.

---

## 6. Known vs Unknown Failures (Automation Boundary)

### Known Failures

Failures you *expect*, *understand*, and *accept*.

Examples:

* Process crash
* Docker restart
* VM reboot

These are safe to automate.

### Unknown Failures

Failures whose root cause is unclear or harmful.

Examples:

* Crash loops
* Data corruption
* Bad environment configuration
* External dependency outage

Automating unknown failures:

* Hides root cause
* Delays detection
* Creates cascading damage

---

## 7. Predictable Recovery (Gold Standard)

A resilient system:

* Fails in known ways
* Recovers in known ways
* Behaves consistently

You should always be able to predict:

* What happens after a crash
* What happens after a reboot
* What happens after daemon restart

If recovery surprises you → **system is unsafe**.

---

## 8. Crash Loops (The Silent Killer)

A crash loop is:

* Fast failure
* Immediate restart
* Repeated endlessly

Why crash loops are dangerous:

* High CPU usage
* Log flooding
* Masked outages
* False sense of uptime

> A restarting container can be **more dangerous than a stopped one**.

---

## 9. Resilience Without Observability Is Reckless

Automation without visibility equals blindness.

You must be able to observe:

* Restart count
* Exit codes
* Last failure reason
* Time between restarts

If you cannot answer:

> “Why did this restart?”

Then auto‑restart should not exist.

---

## 10. Human vs Machine Responsibility

### Machines Are Good At

* Repetition
* Speed
* Known rules

### Humans Are Required For

* Debugging
* Design fixes
* Configuration decisions
* Risk assessment

> Resilience is **division of responsibility**, not removal of humans.

---

## 11. Why Blind Auto‑Restart Is Dangerous (Deep)

Blind restart can:

* Hide broken deployments
* Hide bad releases
* Cause infinite retries
* Damage downstream systems

Production outages often worsen because:

* Automation kept retrying
* No alert triggered
* Humans arrived late

> Restart policies must be **paired with inspection**.

---

## 12. Day‑6 Core Philosophy (Burn This In)

* Failure is expected
* Recovery must be explicit
* Automation has limits
* Restart is a tool, not a solution
* Visibility determines safety

> **The goal is not zero failure.
> The goal is controlled recovery.**

---

## ⏭️ Next Hour (Locked)

Hands‑on experimentation with Docker restart policies.

No theory. No shortcuts. Only break → observe → recover.
