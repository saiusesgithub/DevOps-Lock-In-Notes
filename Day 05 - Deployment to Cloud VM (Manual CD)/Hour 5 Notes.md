# Day 5 — Hour 5

## Breakage & Recovery: Docker Daemon Restart and VM Reboot (Hands-on)

> This hour tested **host-level failures** that happen in real production systems. The goal was to prove that deployment knowledge holds even when **the entire runtime disappears**.

---

## 1. Goal of Hour 5

* Simulate failures beyond the application
* Understand what survives:

  * Docker daemon restart
  * Full VM reboot
* Practice **manual recovery from disk state only**

This hour answers:

> “What actually survives when the machine itself goes down?”

---

## 2. Failure Scenario 1 — Docker Daemon Restart

### Step 2.1 — Restart Docker Service

```bash
sudo systemctl restart docker
```

This simulates:

* Docker upgrade
* Docker daemon crash
* System maintenance

---

### Step 2.2 — Check Running Containers

```bash
docker ps
```

Observed:

* No running containers

---

### Step 2.3 — Inspect All Containers

```bash
docker ps -a
```

Observed:

```
Exited (137)
```

Meaning:

* Container definition still exists
* Process was killed
* Docker daemon did **not** restart containers automatically

---

## 3. Key Lesson — Docker Daemon Restart

Rules locked:

* Docker daemon restart kills running processes
* Docker **does not guarantee uptime by default**
* Containers must be restarted manually unless configured otherwise

> By default, Docker provides **persistence of configuration**, not **persistence of execution**.

---

## 4. Manual Recovery After Docker Restart

### Step 4.1 — Restart Existing Container

```bash
docker start day5
```

---

### Step 4.2 — Verify Runtime State

```bash
docker ps
```

Observed:

* Container returned to `Up` state

---

### Step 4.3 — Verify Logs After Recovery

```bash
docker logs day5 | tail -n 10
```

Observed:

* Application restarted cleanly
* Logs confirmed correct behavior

---

## 5. Failure Scenario 2 — Full VM Reboot

This simulates:

* Cloud provider restart
* Kernel update
* Power loss

---

### Step 5.1 — Reboot the VM

```bash
sudo reboot
```

Effects:

* SSH session terminated
* All memory wiped
* All processes stopped

---

### Step 5.2 — Reconnect After Reboot

After waiting ~60–90 seconds, SSH was re-established.

---

### Step 5.3 — Inspect Runtime State

```bash
docker ps
```

Observed:

* No running containers

```bash
docker ps -a
```

Observed:

* Container definition still present
* Status: `Exited (137)`

---

## 6. Key Lesson — VM Reboot

What survived:

* VM disk
* Git repository
* Docker images
* Docker container definitions

What did NOT survive:

* Running containers
* Process memory
* Runtime state

> After a reboot, **only disk state matters**.

---

## 7. Manual Recovery After VM Reboot

### Step 7.1 — Start Container from Disk State

```bash
docker start day5
```

---

### Step 7.2 — Verify Recovery

```bash
docker ps
```

Observed:

* Container running again
* Application restored without rebuild

---

## 8. Final Deployment Truths Learned

* Reboots erase runtime, not configuration
* Containers are **not services** by default
* Docker alone does not provide uptime guarantees
* Deployment means:

  * Expecting failure
  * Recovering repeatedly
  * Never trusting memory

---

## 9. Forward-Looking Insight (Not Implemented)

Question raised (intentionally not implemented):

> “What would keep this running automatically?”

Correct conceptual answers:

* Docker restart policies
* systemd-managed containers
* Orchestration layers

Automation without understanding was deliberately avoided.

---

### Status After Hour 5

* Docker restart recovery: ✅ mastered
* VM reboot recovery: ✅ mastered
* Manual CD confidence: ✅ earned
* Ready for next phase: **Automatic uptime & resilience**
