# Day 5 — Hour 4

## Logs & Runtime Debugging (Hands-on)

> This hour focused on **observability and failure understanding**, not fixing. The goal was to prove that a running deployment can be **understood, debugged, and recovered using logs only**.

---

## 1. Goal of Hour 4

* Practice reading **historical logs**
* Practice **streaming live logs** from a running container
* Understand the difference between:

  * Container state
  * Process state
  * Docker daemon state
* Intentionally crash the app and recover it **without rebuilding**

This hour answers:

> “When something breaks in production, where do I look first?”

---

## 2. Reading Historical Logs

### Step 2.1 — View Full Logs

```bash
docker logs day5
```

Observed output:

```
App is running inside a Docker container
sleeping for 500
```

Key takeaway:

* Logs persist **after** container start
* Logs can be read even if the container later crashes

---

## 3. Following Live Logs (Critical Skill)

### Step 3.1 — Stream Logs in Real Time

```bash
docker logs -f day5
```

Observed:

* Continuous log output while the container is running
* Log streaming does **not** affect container execution

### Step 3.2 — Detach from Logs

```text
Ctrl + C
```

Important:

> Stopping log streaming does **not** stop the container.

---

## 4. Simulating a Runtime Crash

### Step 4.1 — Kill the Running Container

```bash
docker kill day5
```

Effect:

* Docker sent `SIGKILL` to the main process
* Main process terminated immediately

---

### Step 4.2 — Inspect Container State After Crash

```bash
docker ps -a
```

Observed:

```
Exited (137)
```

Meaning:

* Exit code `137` = process killed by signal
* Container object still exists
* Docker daemon still running

---

## 5. Understanding What Actually Died

Critical distinction learned:

* ❌ Docker did not crash
* ❌ VM did not crash
* ❌ Container object did not disappear
* ✅ **Main process inside the container died**

Rule locked:

> A container lives only as long as its main process lives.

---

## 6. Manual Recovery (No Rebuild, No Re-run)

### Step 6.1 — Restart the Existing Container

```bash
docker start day5
```

---

### Step 6.2 — Verify Container Is Running

```bash
docker ps
```

Observed:

* Container returned to `Up` state

---

### Step 6.3 — Verify Logs After Restart

```bash
docker logs day5 | tail -n 10
```

Observed:

* Logs restarted from the beginning
* Application behavior consistent

---

## 7. Key Lessons from Hour 4

* Logs are the **first and primary debugging tool**
* Containers are not magic — they wrap Linux processes
* Killing a container ≠ killing Docker
* Exit codes matter (`137` = SIGKILL)
* Recovery does not require rebuilding images
* Deployment debugging is **read → observe → act**, not guess

---

## 8. Deployment Mindset Reinforced

* Never assume uptime
* Never assume containers restart themselves
* Always confirm behavior using logs
* Manual recovery is a required skill before automation

---

### Status After Hour 4

* Log access: ✅ confident
* Live debugging: ✅ practiced
* Crash recovery: ✅ manual and correct
* Ready for next phase: **Host-level failures (Docker & VM)**
