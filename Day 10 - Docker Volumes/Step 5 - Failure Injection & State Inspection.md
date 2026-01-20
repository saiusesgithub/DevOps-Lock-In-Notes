# Day 10 — Step 5 (HANDS-ON)

## Failure Injection & State Inspection — **Who Owns the Data?**

**Date:** Jan 16
**Theme:** Docker Volumes + Realism (State and Persistence)

---

## 🎯 Objective of Step 5

Step 5 was designed to **remove all remaining ambiguity** about Docker state by intentionally **breaking things** and inspecting the system to answer one question with certainty:

> **What survives, what doesn’t, and why?**

This step focused on:

* Volume identity
* Inspection over assumption
* Controlled data loss
* Windows-specific storage reality

---

## 🧠 Mental Model Locked Before Execution

### Core truths entering Step 5

* Containers are ephemeral
* Volumes are the persistence boundary
* **Volume name = volume identity**
* Docker does not remember deleted state

If data disappears, it is **always explainable**.

---

## 🔄 Reset Scenario (Realistic Operator Situation)

Before Step 5 execution:

* Previous Compose files were deleted
* Old volumes were removed

This simulated a **real-world return-after-cleanup** scenario.

**Key takeaway:**

> Docker has no memory of deleted volumes. Once removed, state is permanently gone.

---

## 🧪 Experiment 1 — Recreate Minimal Persistent State

### Minimal `docker-compose.yml`

```yaml
services:
  app:
    image: busybox
    command: sh -c "sleep 300"
    volumes:
      - state_vol:/data

volumes:
  state_vol:
```

> No auto-write logic included. This ensures **true persistence**, not regeneration.

---

### Bring the stack up

```bash
docker compose up -d
```

### Write data explicitly

```bash
docker compose exec app sh -c "echo persisted-state > /data/state.txt && ls -l /data"
```

### Verify content

```bash
docker compose exec app sh -c "cat /data/state.txt"
```

### Observed Result

```text
-rw-r--r-- state.txt
persisted-state
```

### Explanation

* `state.txt` was written by the container
* The file lives inside a **Docker-managed named volume**
* The container is only a writer, not the owner

---

## 🧪 Experiment 2 — Inspecting the Truth (No Guessing)

### List volumes

```bash
docker volume ls
```

### Inspect the volume

```bash
docker volume inspect day10_state_vol
```

### Key Field Observed

```text
Mountpoint: /var/lib/docker/volumes/day10_state_vol/_data
```

### Explanation

* This is the **real storage location** used by Docker
* Containers merely mount this location

---

## 🪟 Windows-Specific Reality

### Why this path is not easily browsable

* Named volumes live inside Docker’s **internal Linux VM** on Windows
* `/var/lib/docker/...` is not part of the normal Windows filesystem
* Unlike bind mounts, this path is **not intended for manual access**

**Key distinction:**

> Bind mounts expose host paths; named volumes abstract them.

---

## 💣 Experiment 3 — Failure Injection: Break Volume Identity

### Intentional change

The volume name was changed:

```yaml
volumes:
  state_vol_v2:
```

and mounted as:

```yaml
- state_vol_v2:/data
```

---

### Recreate the stack

```bash
docker compose down
```

```bash
docker compose up -d
```

### Inspect data

```bash
docker compose exec app sh -c "ls -l /data"
```

### Observed Result

```text
total 0
```

### Inspect volumes

```bash
docker volume ls
```

```text
day10_state_vol
day10_state_vol_v2
```

---

## 🧠 Final Explanation (Core Lock-in)

> Changing the volume name broke the link to the old storage. Since the new name did not exist, Docker created a new empty volume. The old data remained in the old volume but was no longer attached.

---

## 🔑 Operator-Level Truths Proven in Step 5

1. **Volume name is the identity**
2. Docker does not infer intent or reconnect old data
3. Deleted volumes are gone permanently
4. Inspection (`docker volume inspect`) beats assumptions
5. On Windows, named volumes live inside Docker’s Linux VM

---

## ⚠️ Common Misconceptions Eliminated

* ❌ Docker remembers old volumes
* ❌ Volume names are cosmetic
* ❌ Seeing files always means persistence
* ❌ Containers own their data

All replaced with observable facts.

---

## ✅ Step 5 Completion Criteria

* Persistent state recreated intentionally
* Volume metadata inspected
* Volume identity broken on purpose
* Data loss explained with certainty

**Step 5: COMPLETE**
