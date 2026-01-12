# 🔁 Day 6 — Hour 2

## Docker Restart Policies (Hands‑On, Failure‑First) — Deep Reference Notes

> These notes are **intentionally very deep**. This is not just what you typed — it is **what you proved, why it behaved that way, and how to reason about it in the future**.
> Treat this as a **long‑term DevOps reference**, not daily notes.

---

## 1️⃣ Purpose of Hour 2 (Why This Hour Exists)

Most people "learn" Docker restart policies by:

* reading a table
* memorizing definitions
* assuming behavior

Hour 2 exists to **destroy assumptions**.

The real goals were:

* Observe **actual container lifecycle transitions**
* See how Docker reacts to **process exits vs human intent**
* Understand how **restart logic is evaluated after daemon restarts and VM reboots**
* Internalize what Docker can **guarantee** vs what it **never attempts to solve**

This hour is the boundary between:

> *"I know the command"*
> *"I understand the system"*

---

## 2️⃣ Why We Used `busybox sh -c` (Deep Explanation)

### What BusyBox Really Is

**BusyBox** is a single binary that implements dozens of core Unix utilities.

Internally:

* One executable
* Many commands via applets
* Extremely small surface area

BusyBox is used in:

* initramfs
* embedded Linux
* recovery environments
* container testing

It is intentionally:

* simple
* predictable
* fast

> BusyBox removes *everything* except process behavior.

---

### Why BusyBox Is Perfect for Restart‑Policy Learning

Restart policies depend on only **one thing**:

> *What happens to PID 1?*

BusyBox lets us:

* create a process
* control its exit code
* guarantee timing
* avoid side effects

There is:

* no web server
* no framework
* no ports
* no config files

Just:

> start → run → exit

This isolates **Docker’s decision‑making logic**.

---

### `sh -c` Explained Properly

```bash
sh -c "echo START; sleep 2; exit 1"
```

Breakdown at the OS level:

* `sh` becomes **PID 1** inside the container
* `-c` tells the shell to interpret the following string

Command sequence:

1. `echo START` → visible marker in logs
2. `sleep 2` → gives time to observe container state
3. `exit 1` → explicit non‑zero exit (failure)

Critical rule:

> Docker watches **PID 1 only**. Nothing else matters.

If PID 1 exits:

* container exits
* restart policy is evaluated

---

### Why We Did NOT Use `.sh` Files

Using scripts introduces **irrelevant variables**:

* file permissions
* COPY vs bind mounts
* image rebuilds
* filesystem persistence

Hour 2 is about **policy behavior**, not packaging.

Scripts will return later — after the mental model is locked.

---

## 3️⃣ Baseline: No Restart Policy (Control Case)

### Command

```bash
docker run --name crash-test-no busybox sh -c "echo START; sleep 2; exit 1"

docker ps -a
```

### Observed Reality

* Container started
* PID 1 exited with code `1`
* Container transitioned to `Exited`
* Docker took **no further action**

### Meaning

This establishes the default truth:

> Docker does **nothing** unless explicitly instructed.

---

## 4️⃣ Explicit `--restart no`

### Command

```bash
docker rm crash-test-no

docker run --name crash-test-no --restart no busybox sh -c "echo START; sleep 2; exit 1"
```

### Observed Reality

* Behavior identical to default

### Meaning

* `no` is not a special mode
* It simply documents intent

> Default Docker behavior = `restart: no`

---

## 5️⃣ `on-failure`: Exit‑Code‑Driven Recovery

### Command

```bash
docker run --name crash-test-onfail --restart on-failure busybox sh -c "echo START; sleep 2; exit 1"
```

### Observed Reality

* Container restarted repeatedly
* `RestartCount` increased
* Crash loop occurred

### Key Insight

Docker logic for `on-failure`:

```text
if exit_code != 0:
    restart
else:
    stop
```

Docker does NOT ask:

* why it failed
* whether retry is safe
* whether failure is permanent

It only checks the **exit code**.

---

## 6️⃣ Human Stop vs Failure (`on-failure`)

### Command

```bash
docker stop crash-test-onfail
```

### Observed Reality

* Container stayed stopped
* Restart policy was ignored

### Meaning

Docker differentiates between:

* **process failure**
* **human intent**

> Human intent always overrides restart logic.

---

## 7️⃣ Docker Daemon Restart (`on-failure`)

### Command

```bash
sudo systemctl restart docker
```

### Observed Reality

* Docker daemon restarted
* Container was evaluated again
* Restart policy applied
* Container came back automatically

### Meaning

* Docker treats daemon restarts like crashes
* Restart policy is re‑evaluated on startup

---

## 8️⃣ VM Reboot (`on-failure`)

### Command

```bash
sudo reboot
```

### Observed Reality

* VM rebooted
* Docker daemon started on boot
* `on-failure` container restarted automatically

### Meaning

> `on-failure` provides **VM‑level recovery** for crashing processes.

---

## 9️⃣ `always`: Unconditional Recovery

### Command

```bash
docker run --name crash-test-always --restart always busybox sh -c "echo START; sleep 2; exit 1"
```

### Observed Reality

* Exit code ignored
* Container restarted continuously
* Crash loop intensified

### Meaning

Docker logic for `always`:

```text
if container stops AND not human_stop:
    restart
```

Exit codes are irrelevant.

---

## 🔟 `unless-stopped`: Memory of Human Intent

### Command

```bash
docker run --name crash-test-unless-stopped --restart unless-stopped busybox sh -c "echo START; sleep 2; exit 1"
```

### Initial Behavior

* Identical to `always`
* Crash loop observed

---

### Human Stop + Daemon Restart

```bash
docker stop crash-test-unless-stopped
sudo systemctl restart docker
```

### Observed Reality

* Container remained stopped
* Docker remembered the human decision

### Meaning

> `unless-stopped` = `always` + memory

Docker persists human intent across:

* daemon restarts
* VM reboots

---

## 1️⃣1️⃣ Restart Policy Behavior Matrix (PROVEN)

| Policy           | Exit 0 | Exit ≠ 0 | Crash | Human Stop | Daemon Restart | VM Reboot      |
| ---------------- | ------ | -------- | ----- | ---------- | -------------- | -------------- |
| `no`             | ❌      | ❌        | ❌     | ❌          | ❌              | ❌              |
| `on-failure`     | ❌      | ✅        | ✅     | ❌          | ✅              | ✅              |
| `always`         | ✅      | ✅        | ✅     | ❌          | ✅              | ✅              |
| `unless-stopped` | ✅      | ✅        | ✅     | ❌          | ❌ (if stopped) | ❌ (if stopped) |

---

## 1️⃣2️⃣ Critical Mental Models Locked

* Docker reacts to **process state**, not correctness
* Restart policies are **mechanical rules**, not intelligence
* Crash loops are a **danger sign**, not success
* Human intent always overrides automation
* Restart policies provide **predictability**, not reliability

---

# 🔁 Restart Policies — Human Stop vs Daemon / VM Restart

## The Exact Doubt (Clarified)

**Question:**

> In `always` / `on-failure` — if I manually stop the container, then restart the Docker daemon or reboot the VM, will it automatically start again? And does this NOT happen in `unless-stopped`?

---

## Short Answer (Precise)

✅ **YES** — in `always` and `on-failure`

* If you **manually stop** the container
* Then **restart Docker** or **reboot the VM**
  ➡️ Docker will **start the container again automatically**

❌ **NO** — in `unless-stopped`

* If you **manually stop** the container
* Then **restart Docker** or **reboot the VM**
  ➡️ Docker will **NOT start the container again**

---

## Why This Happens (Mental Model)

Docker distinguishes between:

* **Process failure** (crash, exit, daemon restart, reboot)

* **Human intent** (`docker stop`)

* `always` and `on-failure` **forget human intent** after a daemon restart or reboot

* `unless-stopped` **remembers human intent** across daemon restarts and VM reboots

---

## One-Line Rule to Remember

> **Only `unless-stopped` remembers that a human stopped the container across Docker restarts and VM reboots.**

---

## Quick Comparison Table

| Policy           | Manual Stop         | Docker Restart / VM Reboot |
| ---------------- | ------------------- | -------------------------- |
| `no`             | stays stopped       | stays stopped              |
| `on-failure`     | stays stopped (now) | ❌ restarts                 |
| `always`         | stays stopped (now) | ❌ restarts                 |
| `unless-stopped` | stays stopped       | ✅ stays stopped            |

---

## Why This Matters

* `always` / `on-failure` → good for services that **must come back** after reboot
* `unless-stopped` → safer when **human maintenance decisions must persist**

This behavior is intentional and critical for production safety.

---
## 1️⃣3️⃣ Hour‑2 Final Realization

> Docker restart policies do not prevent failure.
> They only define **how failure is handled**.

You now know — from evidence — exactly:

* what Docker can self‑heal
* what it will never fix
* where automation stops
* where humans must step in

Hour 2 is **fully complete**.


------------
-----------

so if i use no , no restarts , in on failure - it restarts if exit code != 0 and if i restart the daemon/vm , it restarts and if != 0 again , it keeps on restarting ,,,,,, and always - restarts no matter exit code, restarts if i restart vm /daemon ,,,,,, and unless-stopped - restarts no matter exit code , and if i restart the daemon/vm without stopping service , restarts and if i stop the service before restarting daemon / vm , doesnt restart  


🔹 restart: no

❌ No restarts ever
❌ Exit code doesn’t matter
❌ Docker daemon restart → no restart
❌ VM reboot → no restart
👉 Docker never intervenes.

🔹 restart: on-failure

✅ Restarts only if exit code ≠ 0
❌ Does NOT restart if exit code = 0
❌ If you stop the container, it stays stopped for now
✅ If Docker daemon restarts → container restarts
✅ If VM reboots → container restarts
🔁 If it keeps exiting with ≠ 0 → it keeps restarting (crash loop)
👉 Exit code–driven recovery + forgets human stop across restarts.

🔹 restart: always

✅ Restarts no matter the exit code (0 or ≠ 0)
❌ If you stop the container → stays stopped for now
✅ Docker daemon restart → container restarts
✅ VM reboot → container restarts
🔁 Can easily cause infinite crash loops
👉 Strongest auto-restart, no memory of human stop.

🔹 restart: unless-stopped

✅ Restarts no matter the exit code
✅ Docker daemon restart → restarts if you did NOT stop it
✅ VM reboot → restarts if you did NOT stop it
❌ If you stop the container before daemon restart / VM reboot → it does NOT restart
👉 Same as always, but remembers human intent across restarts.