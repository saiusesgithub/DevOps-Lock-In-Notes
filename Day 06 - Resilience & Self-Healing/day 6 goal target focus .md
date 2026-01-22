# 📅 Day 6 GOAL TARGET FOCUS — Failure, Resilience & Restart Strategy (Self‑Healing Basics)

**Date:** January 12
**Focus:** Failure modes, Docker restart policies, self‑healing limits, human vs automation boundaries
**Environment:** Ubuntu EC2 (long‑lived VM) + Docker Engine (no orchestrators)

---

## 🎯 Objective for the Day

The goal for Day 6 was **not** to memorize Docker restart policies or run a few commands.

The real objective was to move from:

> *“If my container crashes, I’ll SSH in and fix it”*
> to
> *“I know exactly which failures recover automatically, which don’t, and why.”*

By the end of the day:

* Recovery should feel **mechanical and predictable**
* Restart policies should feel like **rules**, not guesses
* Failures should feel **classifiable**, not confusing
* I should know when **automation helps** and when it is **dangerous**

If containers were restarting without me understanding *why*, the day would be considered a failure.

---

## 🧠 Mental Models Established

Before heavy execution, I locked these foundations.

### Self‑Healing ≠ Fixing

* Docker can **restart processes**
* Docker cannot **fix bugs**
* Automation only reacts to **known failure signals** (exit codes, crashes)

Restarting is **recovery**, not correctness.

---

### Availability ≠ Deployment

* Deployment = getting software onto a machine
* Availability = software being reachable over time

Day 5 proved I can deploy.
Day 6 focused on **staying alive without human intervention**.

---

### Automation Has Limits

* Blind restarts can hide real problems
* Crash loops are signals, not solutions
* Human intent must override automation

This mental boundary guided every experiment today.

---

## 🧱 Hour 1 — Resilience Mental Model (No Commands)

Focus:

* What does “self‑healing” actually mean?
* What failures repeat vs never resolve?
* Why systems are allowed to fail

Key outcomes:

* Accepted that **failure is normal**
* Understood that the goal is **predictable recovery**, not zero failure
* Set guardrails before touching Docker restart flags

This hour prevented blind experimentation later.

---

## 🧱 Hour 2 — Docker Restart Policies (Hands‑On, Failure‑First)

Focus:

* `no`
* `on-failure`
* `always`
* `unless-stopped`

Approach:

* Used **BusyBox** to simulate controlled crashes
* Forced non‑zero exit codes
* Observed:

  * crash behavior
  * human stop behavior
  * Docker daemon restarts
  * VM reboots

Key unlocks:

* Docker only watches **PID 1**
* Exit codes matter only for `on-failure`
* Human `docker stop` always overrides automation
* Restart policies are **mechanical**, not intelligent

This hour turned restart policies from theory into **proven behavior**.

---

## 🧱 Hour 3 — Applying Policies to a Real Image (Day 5 App)

Focus:

* Apply restart policies to an actual Dockerfile + app
* Observe behavior with a **short‑lived job**

Key realizations:

* My app is a **one‑time job**, not a long‑running service
* Using `always` on such apps causes **infinite restart loops**
* Restart policy choice must match **application nature**

Mistakes caught:

* Expecting restart policies to “help” successful exits
* Assuming restarts imply correctness

This hour connected restart logic to **real design decisions**.

---

## 🧱 Hour 4 — Failure Classification (Critical Thinking)

Focus:

Explicitly classifying failures:

* Logic bug
* Broken image
* DB unavailable
* Network glitch
* CPU spike
* VM reboot

Key corrections learned:

* Logic bugs → ❌ never self‑heal
* Broken images → ❌ infinite restart loops
* Temporary infra issues → ✅ may recover
* VM reboot → ✅ restart policy works

This hour trained **operator judgment**, not tooling knowledge.

---

## 🧱 Hour 5 — Rebuild‑From‑Memory Test

Focus:

* New SSH session
* No notes
* Delete images
* Rebuild Dockerfile
* Run containers with restart policies
* Restart Docker daemon
* Reboot VM

Outcome:

* Recovery behavior became predictable
* RestartCount and logs finally made sense
* Debugging felt calm, not reactive

This validated that understanding was **internalized**, not memorized.

---

## 🧱 Hour 6 — Reflection & Limits of Docker‑Only Recovery

Focus:

* Acknowledged limitations of the example app
* Reflected on why:

  * restart ≠ health
  * restart ≠ observability
  * Docker alone doesn’t scale

Prepared ground for:

* health checks
* readiness vs liveness
* higher‑level orchestration (later)

---

## 🔑 Key Lessons Locked In

* Restart policies enforce **process survival**, not correctness
* Human intent always overrides automation
* Crash loops are warnings, not fixes
* Service vs job distinction matters
* Failure classification is mandatory before automation

---

## ✅ End‑of‑Day Reflection

By the end of Day 6, I can confidently say:

> I understand exactly which failures Docker can automatically recover from, which ones it cannot, and why. Restart policies no longer feel magical — they feel mechanical, predictable, and bounded. I can design recovery behavior intentionally instead of relying on blind restarts.

**Day 6 was completed successfully.**

------------------

CONTEXT HANDED TO MAIN CHAT - 

📅 DAY 6 — FULL HOUR-WISE CONTEXT (FOR MAIN PLAN CHAT)
Overall Reality Check

Day 6 was not smooth or fast — it was deep, messy, and correct.
A lot of confusion happened on purpose, and was resolved through repeated hands-on testing.
By the end of the day, restart policies stopped being “options” and became mechanical systems I can reason about.

⏱️ HOUR 1 — Resilience Mental Model (Conceptual Grounding)
What I did

Did not run commands immediately

Slowed down to understand what “self-healing” actually means

Clarified that:

availability ≠ deployment

restart ≠ fix

automation ≠ intelligence

Explicitly accepted that:

Docker cannot fix logic bugs

Docker only reacts to process lifecycle

The goal is predictable recovery, not “never fail”

What I learned

Restart mechanisms only work for known, repeatable failure modes

Blind automation is dangerous

If you don’t classify failures, restart policies can hide real problems

This hour set the mental guardrails for the rest of the day

Level after Hour 1

Conceptually aligned, but still abstract — needed proof.

⏱️ HOUR 2 — Docker Restart Policies (Deep Hands-On, BusyBox)
What I did

Started testing restart policies one by one

Used busybox sh -c to simulate controlled crashes

Ran containers that:

exit with code 1

exit with code 0

sleep briefly then crash

Tested:

no

on-failure

always

unless-stopped

Major confusion points (important)

I did not understand initially:

what busybox actually is

what sh -c does

why PID 1 matters

I asked explicitly:

“What is this busybox sh -c thing? Can I just use nano and a .sh file?”

This led to a deep clarification:

BusyBox = minimal Linux userspace, ideal for crash testing

sh -c executes inline commands without filesystem complexity

Whatever runs via sh -c becomes PID 1

Docker tracks only PID 1, not internal logic

This was a big conceptual unlock.

What I tested (real actions)

Crash → observe restart

docker stop → observe override of restart policy

systemctl restart docker

VM reboot

docker inspect RestartCount

docker logs to detect crash loops

What I learned

on-failure cares about exit code

always restarts regardless of exit code

unless-stopped behaves like always until a human stops it

Human intent always overrides automation

RestartCount + logs are critical to detect crash loops

Level after Hour 2

Restart policies became mechanical, not magical

I could predict behavior before running commands

⏱️ HOUR 3 — Applying Restart Policies to a Real Image (Day 5 App)
What I did

Went back to my Day 5 Dockerfile + app.sh

Rebuilt the image from scratch

Ran it with different restart policies

Observed behavior with:

short-lived app

exit code 0

Intentionally caused restart loops using always and unless-stopped

Important realization

My app is a one-time job, not a service

Restarting it on success makes no sense

Using always on short-lived jobs causes infinite restarts

This was a practical design insight, not theory.

Mistakes I made (and fixed)

Expected restart policies to “help” even when the app exits normally

Forgot that restart policy must match app nature

Initially confused by RestartCount resetting after daemon restart

Level after Hour 3

I understood that restart policies must be chosen deliberately

Restart ≠ reliability

Service vs job distinction became clear

⏱️ HOUR 4 — Failure Classification (Mental Model Stress Test)
What I did

Classified failures interactively:

app bug

logic bug

DB down

network glitch

CPU spike

broken image

VM reboot

I initially gave wrong answers for some cases

Corrected myself after reasoning

Key corrections

Logic bugs → ❌ never self-heal

Broken images → ❌ restart loop forever

Temporary DB/network issues → ✅ might recover

VM reboot → ✅ restart policy works

Resource spikes → depends on cause

What I learned

Restart loops are signals, not solutions

Automation without classification is dangerous

You must know when to stop the container manually

Level after Hour 4

I can now judge whether automation is appropriate

This is where “operator thinking” started

⏱️ HOUR 5 — Rebuild-From-Memory Test (Validation)
What I did

New SSH session

No notes

Deleted images

Rebuilt Dockerfile

Re-ran containers with different restart policies

Restarted Docker daemon

Rebooted VM

Verified which containers came back automatically

Observations

on-failure behaved exactly as expected

unless-stopped remembered human stops across daemon/VM restart

RestartCount behavior now made sense

Logs clearly showed crash loops vs normal behavior

Level after Hour 5

Confidence improved

I could debug without panic

Recovery behavior felt predictable

⏱️ HOUR 6 — Reflection, Edge Cases & Limits
What I did

Acknowledged that my app is too basic for real resilience testing

Still used it to practice mechanics

Reflected on:

why orchestrators exist

why restart ≠ health

why health checks matter (future topic)

Final understanding

Docker restart policies are low-level safety nets

They are not observability

They are not correctness checks

They are not substitutes for design

🧠 Final State After Day 6

I can now confidently say:

I know exactly what Docker can self-heal

I know exactly what Docker cannot

I understand restart loops

I understand human override

I understand service vs job behavior

I can explain restart policies without notes

Docker no longer feels “smart” — it feels mechanical

⏭️ Ready For

Health checks (liveness vs readiness)

Detecting bad restarts automatically

Why Docker alone is insufficient at scale

Moving toward higher-level orchestration with correct mental models