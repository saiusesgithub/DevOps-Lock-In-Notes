# Day 10 — Step 2 (HANDS-ON)

## Named Volume Experiment — **Proving Persistence**

**Date:** Jan 16
**Theme:** Docker Volumes + Realism (State and Persistence)

---

## 🎯 Objective of Step 2

This step was designed to **prove with evidence (not theory)** that:

1. Data written to a **named volume** survives container deletion
2. A **new container** using the same volume sees old data
3. Deleting the **volume itself** permanently destroys the data
4. Volume *names* are identifiers, not history

This step moved from *mental model* → *falsifiable experiments*.

---

## 🧠 Rules Followed During This Step

* CLI only (no Docker Desktop)
* Predict → Execute → Observe → Explain loop
* 2–3 commands at a time
* No notes during execution
* No skipping destructive steps

---

## 🧠 Pre-Execution Predictions (Locked Before Commands)

### Prediction 1

**Scenario:**

* Container writes `hello.txt` into `/data`
* `/data` is backed by a named volume
* Container is deleted

**Prediction:**

* File will still exist inside the Docker-managed volume on the host

---

### Prediction 2

**Scenario:**

* New container mounts the same named volume at `/data`

**Prediction:**

* The new container will see `hello.txt` with the same contents

---

### Prediction 3 (initially fuzzy → clarified)

**Scenario:**

* Named volume is deleted
* A container mounts the same volume name again

**Clarified Truth:**

* Docker auto-creates a **new empty volume**
* No error is thrown
* Old data is permanently lost

---

### Prediction 4

**Scenario:**

* Image is rebuilt in between

**Prediction:**

* Rebuilding an image does **not** affect volume data
* Image = template, volume = stored data

---

## 🧪 Experiment 1 — Create a Named Volume

### Command

```bash
docker volume create day10_test_volume
```

### Expected / Observed Output

```text
day10_test_volume
```

### Explanation

* Docker created a **named volume**
* This is Docker-managed persistent storage on the host
* No container is associated yet

---

## 🧪 Experiment 2 — Write Data into the Volume via a Container

### Command

```bash
docker run --name vol-test-1 -v day10_test_volume:/data alpine sh -c "echo hello-from-volume > /data/hello.txt && ls -l /data"
```

### Observed Output

```text
total 4
-rw-r--r--    1 root     root            18 Jan 16 11:44 hello.txt
```

### Follow-up Command

```bash
docker rm vol-test-1
```

### Observation

* Container was deleted
* File still exists conceptually inside the volume

### Explanation

* The container was only a runtime
* The file was written into the **volume**, not the container’s writable layer

---

## 🧪 Experiment 3 — Reuse the Same Volume with a New Container

### Command

```bash
docker run --name test -v day10_test_volume:/data busybox sh -c "ls -l /data && cat /data/hello.txt"
```

### Observed Output

```text
total 4
-rw-r--r--    1 root     root            18 Jan 16 11:44 hello.txt
hello-from-volume
```

### Follow-up Command

```bash
docker rm test
```

### Explanation (User)

> Container was deleted but volume wasn’t deleted because it’s Docker-managed and not temporary. The data from the previous container stayed, and we attached that volume to the new container, so the same data appeared.

### Operator Truth Locked

* Container lifecycle ≠ Volume lifecycle
* New container + same volume = same data

---

## 🧪 Experiment 4 — Destructive Proof (Volume Deletion)

### Command

```bash
docker volume rm day10_test_volume
```

### Observed Output

```text
day10_test_volume
```

### Verify Volumes

```bash
docker volume ls
```

### Observed Output

```text
DRIVER    VOLUME NAME
```

---

## 🧪 Experiment 5 — Reuse Volume Name After Deletion

### Command

```bash
docker run --name test -v day10_test_volume:/data busybox sh -c "ls -l /data"
```

### Observed Output

```text
total 0
```

### Cleanup

```bash
docker rm test
```

---

## 🧠 Final Explanation (User)

> The volume itself was deleted by the user command. Since the volume didn’t exist anymore, Docker created a new empty volume with the same name. The old data was permanently lost.

---

## 🔑 Core Truths Proven in Step 2

1. **Containers are disposable**

   * Deleting a container does not affect data stored in volumes

2. **Volumes are the persistence boundary**

   * Data lives with the volume, not the container

3. **Volume deletion is irreversible**

   * Once removed, data is gone

4. **Volume names are not magic**

   * Same name after deletion ≠ same data

---

## 🧠 Operator Reflex Built

I can now confidently answer:

* Where data lives
* What survives container deletion
* What must be deleted to reset state
* Why new containers can see old data

---

## ✅ Step 2 Completion Criteria

* Persistence proven with evidence
* Destructive case tested
* Predictions validated
* Confusion eliminated

**Step 2: COMPLETE**
