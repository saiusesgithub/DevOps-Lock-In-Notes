# Day 10 — Step 4 (SYSTEM-LEVEL)

## Volumes + Docker Compose — **Stack Lifecycle vs Data Lifecycle**

**Date:** Jan 16
**Theme:** Docker Volumes + Realism (State and Persistence)

---

## 🎯 Objective of Step 4

This step exists to move from **single-container thinking** to **system-level thinking**.

The goal was to *prove with evidence* that:

1. Docker Compose manages **systems**, not just containers
2. Containers and networks are **runtime artifacts**
3. Volumes are **persistent resources** with a separate lifecycle
4. `docker compose down` and `docker compose down -v` are **fundamentally different commands**
5. Seeing a file does **not automatically mean persistence**

---

## 🧠 Mental Model Before Execution

### Three independent lifecycles in Compose

| Layer     | Lifecycle | Destroyed by default? |
| --------- | --------- | --------------------- |
| Container | Runtime   | Yes (`compose down`)  |
| Network   | Runtime   | Yes (`compose down`)  |
| Volume    | Data      | ❌ No (unless `-v`)    |

Compose orchestrates containers and networks, **not data by default**.

---

## 🧪 Compose Configuration Used

### `docker-compose.yml`

```yaml
version: "3.8"

services:
  app:
    image: busybox
    command: sh -c "echo created-by-compose > /data/compose.txt && sleep 300"
    volumes:
      - compose_data:/data

volumes:
  compose_data:
```

### Important detail

The startup command **always writes `compose.txt` on container start**.
This becomes critical later.

---

## 🧪 Experiment 1 — Bring the Stack Up

### Command

```bash
docker compose up -d
```

### Observed Output

```text
✔ Network day10_default        Created
✔ Volume "day10_compose_data"  Created
✔ Container day10-app-1        Started
```

### Verification

```bash
docker compose ps
```

```text
day10-app-1   busybox   Up
```

### Inspect data inside container

```bash
docker compose exec app sh -c "ls -l /data && cat /data/compose.txt"
```

```text
-rw-r--r-- compose.txt
created-by-compose
```

### Explanation

* The container executed the command from `docker-compose.yml`
* The file was written **into `/data`**, which is backed by a **named volume**
* The file lives in the volume, not in the container or image

---

## 🪟 Windows + Git Bash Nuance (Compose Exec)

### Issue encountered

Running:

```bash
docker compose exec app ls -l /data
```

Resulted in:

```text
ls: C:/Program Files/Git/data: No such file or directory
```

### Why

* Git Bash rewrites Unix-style paths
* `/data` was translated into a Windows path
* Docker received an invalid path for the container

### Correct approach on Windows

```bash
docker compose exec app sh -c "ls -l /data"
```

### Key lesson

> Named volumes are OS-agnostic, but **exec path handling is not**.

---

## 🧪 Experiment 2 — Non-Destructive Teardown

### Command

```bash
docker compose down
```

### Observed Output

```text
✔ Container removed
✔ Network removed
```

### What did NOT happen

* Volume was **not** removed

---

## 🧪 Experiment 3 — Bring Stack Back Up

### Command

```bash
docker compose up -d
```

### Verify data

```bash
docker compose exec app sh -c "ls -l /data && cat /data/compose.txt"
```

```text
-rw-r--r-- compose.txt
created-by-compose
```

### Explanation

* Same volume name reused
* Data available again
* `docker compose down` does not delete volumes

---

## 🧪 Experiment 4 — Destructive Teardown (`-v` flag)

### Command

```bash
docker compose down -v
```

### Observed Output

```text
✔ Container removed
✔ Network removed
✔ Volume removed
```

### Verify volumes

```bash
docker volume ls
```

```text
(local volumes except compose_data)
```

---

## 🧪 Experiment 5 — Recreate Stack After Destruction

### Command

```bash
docker compose up -d
```

### Verify data

```bash
docker compose exec app sh -c "ls -l /data"
```

```text
-rw-r--r-- compose.txt
```

---

## ⚠️ Critical Insight — False Persistence

At first glance, it looked like the data **survived** `down -v`.

This was **incorrect**.

### Why the file still existed

The container startup command:

```bash
echo created-by-compose > /data/compose.txt
```

runs **every time the container starts**.

So:

* Old volume was deleted
* New empty volume was created
* Container recreated the file on startup

### Core lesson

> **Seeing a file does NOT mean persistence.**

You must always ask:

* Was the data **restored**?
* Or was it **recreated**?

---

## 🧠 Operator-Level Truths Locked

1. `docker compose down` ≠ data deletion
2. `docker compose down -v` = data destruction
3. Volumes have a lifecycle independent of stacks
4. Containers can regenerate data and mask data loss
5. Persistence must be verified across destruction **without regeneration**

---

## ⚖️ Compose Command Comparison

| Command           | Containers | Network   | Volumes   |
| ----------------- | ---------- | --------- | --------- |
| `compose down`    | ❌ removed  | ❌ removed | ✅ kept    |
| `compose down -v` | ❌ removed  | ❌ removed | ❌ removed |

---

## ✅ Step 4 Completion Criteria

* Compose + volume interaction proven
* Destructive vs non-destructive teardown understood
* False persistence identified
* System-level lifecycle clarity achieved

**Step 4: COMPLETE**
