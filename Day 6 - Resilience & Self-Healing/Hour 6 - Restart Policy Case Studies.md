# 🔥 Day 6 — Hour 6

## Restart Policies in the Real World (Case Studies & Design Judgment)

> This hour consolidates **everything learned in Day 6** by applying restart‑policy reasoning to **realistic workloads**.
> The focus is **decision‑making**, not commands.

---

## 1️⃣ Objective of Hour 6

The goal of Hour 6 is to answer this confidently:

> **“Given a workload, I can choose the correct restart policy — and explain why every other choice is wrong.”**

This hour moves from:

* *mechanics* (Hour 2)
* *behavior proof* (Hour 3)
* *failure classification* (Hour 4)
* *rebuild mastery* (Hour 5)

➡️ to **production judgment**.

---

## 2️⃣ Core Principle (Day‑6 Master Rule)

> **Restart policies do not describe reliability — they describe intent.**

Docker does not know:

* what your app does
* whether it is healthy
* whether restarting helps

Docker only knows:

* the container stopped
* what rule you gave it

Therefore:

> **The same restart policy can be correct for one app and dangerous for another.**

---

## 3️⃣ Case Study 1 — One‑Shot / Batch Script

### Example: Data Processing Script

```bash
#!/bin/bash
python process_data.py
python upload_results.py
exit 0
```

### Characteristics

* Runs once
* Performs a task
* Exits intentionally
* No expectation of being long‑running

### Correct Restart Policy

```
restart: no
```

### Why This Is Correct

* Successful exit is expected
* Restarting adds no value
* Failures indicate logic or data issues
* Human intervention is required on failure

### What Goes Wrong With Other Policies

| Policy           | Problem                          |
| ---------------- | -------------------------------- |
| `always`         | Infinite restart loop on success |
| `on-failure`     | Hides real errors by retrying    |
| `unless-stopped` | Still loops on success           |

---

## 4️⃣ Case Study 2 — Simple API Service

### Example: Node.js / Python API

```bash
node server.js
# or
python app.py
```

### Characteristics

* Long‑running process
* Exposes HTTP endpoints
* Exit usually means something went wrong

### Correct Restart Policy

```
restart: unless-stopped
```

### Why This Is Correct

* App should always be running
* Crashes should be auto‑recovered
* Human stops (maintenance) must persist
* Survives Docker restarts and VM reboots

### What Goes Wrong With Other Policies

| Policy       | Problem                                      |
| ------------ | -------------------------------------------- |
| `no`         | Manual intervention required after crash     |
| `always`     | May resurrect intentionally stopped services |
| `on-failure` | Exit code 0 edge cases can stop service      |

---

## 5️⃣ Case Study 3 — Background Worker / Consumer

### Example: Queue Consumer

```bash
python consume_messages.py
```

### Characteristics

* Long‑running
* Dependent on external systems (queue, DB)
* Crashes may occur due to transient issues

### Correct Restart Policy

```
restart: on-failure
```

### Why This Is Correct

* Restarts only when something goes wrong
* Avoids restart on graceful shutdown
* Recovers from transient dependency failures

### What Goes Wrong With Other Policies

| Policy   | Problem                           |
| -------- | --------------------------------- |
| `always` | Restarts even on clean shutdown   |
| `no`     | Manual restart needed after crash |

---

## 6️⃣ Case Study 4 — More Complex Shell Script (Hybrid)

### Example: Startup + Service Script

```bash
#!/bin/bash

init_checks.sh || exit 1
migrate_db.sh || exit 1
exec gunicorn app:app
```

### Characteristics

* Short‑lived init phase
* Then becomes a long‑running service
* Exit during init = fatal
* Exit during runtime = crash

### Correct Restart Policy

```
restart: unless-stopped
```

### Why This Is Correct

* Init failures should surface clearly
* Runtime crashes should auto‑recover
* Human stops should persist across reboots

### Critical Design Insight

> **Complex containers often mix one‑shot logic and services.**

Restart policy should match the **longest‑lived responsibility**, not the first command.

---

## 7️⃣ Anti‑Patterns to Avoid (Day‑6 Warnings)

### ❌ Blind `restart: always`

* Masks deterministic failures
* Creates crash loops
* Hides broken deployments

### ❌ Restarting Broken Systems

* Bad config
* Schema mismatch
* Broken image

> Restarting does not fix correctness.

---

## 8️⃣ Decision Checklist (Use This in Real Projects)

Before choosing a restart policy, ask:

1. Is this workload **long‑running or one‑shot**?
2. Does a restart **increase the chance of recovery**?
3. Are failures **transient or deterministic**?
4. Should **human stops persist** across reboots?
5. Is an infinite restart loop acceptable?

If you cannot answer these — do **not** add automation yet.

---

## 9️⃣ Hour‑6 Final Takeaway

> **Correct restart policies are a design decision, not a Docker feature.**

By the end of Hour 6, you should be able to:

* justify every restart policy choice
* explain failure behavior before it happens
* avoid dangerous automation patterns

This completes **Day 6 — Failure, Resilience & Restart Strategy**.
