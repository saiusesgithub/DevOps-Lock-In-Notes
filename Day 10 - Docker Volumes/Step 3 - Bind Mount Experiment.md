# Day 10 — Step 3 - Bind Mount Experiment — **Host-Level Realism**

**Date:** Jan 16
**Theme:** Docker Volumes + Realism (State and Persistence)

---

## 🎯 Objective of Step 3

This step exists to make Docker persistence feel **physically obvious**, not conceptual.

By the end of this step, the goal was to **prove through direct observation** that:

1. A bind mount is a **direct mapping to a real host folder**
2. Changes made inside a container appear **immediately on the host**
3. Changes made on the host appear **immediately inside the container**
4. Persistence with bind mounts exists because the **host filesystem exists**, not because of Docker-managed storage

---

## 🧠 Mental Model Before Execution

### What a bind mount actually is

A bind mount is **not Docker storage**.

It is:

* a literal host directory
* mapped into the container at a specified path

When a bind mount is active:

* the container does not “own” the data
* Docker does not manage the data lifecycle
* the host filesystem is the source of truth

---

## 🔁 Lifecycle Comparison (Critical)

### Container lifecycle

* start / stop / delete
* fully disposable

### Bind mount lifecycle

* tied to the host filesystem
* independent of Docker
* survives container deletion, Docker restart, and system reboot

This is why bind mounts feel **more real** than named volumes.

---

## 🧪 Experiment Setup

### Host directory structure

A real directory was created on the host:

```text
day10/
└── bind-test/
```

This directory was used as the bind mount source.

---

## 🧪 Experiment 1 — Container → Host (Write from container)

### Command

```bash
docker run --name bind-test-1 \
  -v "$(pwd -W)/bind-test:/data" \
  busybox sh -c "echo created-inside-container > /data/inside.txt && ls -l /data"
```

### Observed Result (inside container)

```text
-rw-r--r-- 1 root root 25 inside.txt
```

### Observed Result (on host)

```bash
ls -l bind-test/
```

```text
-rw-r--r-- 1 Saisr 25 inside.txt
```

### Explanation

* The file was created **inside the container**
* The same file appeared **immediately on the host**
* This proves the container was writing directly to the host folder

---

## 🧪 Experiment 2 — Host → Container (Write from host)

### Host-side command

```bash
echo edited-from-host > bind-test/host.txt
```

### Container-side verification

```bash
docker run --name bind-test-2 \
  -v "$(pwd -W)/bind-test:/data" \
  busybox sh -c "ls -l /data && cat /data/host.txt"
```

### Observed Result

```text
-rwxrwxrwx 1 root root 17 host.txt
edited-from-host
```

### Explanation

* The file was created on the **host**
* The container saw it instantly
* No copy, no sync, no Docker magic — same directory

---

## 🪟 Windows-Specific Bind Mount Reality (IMPORTANT)

### What happened

When running Docker on **Windows using Git Bash**, a normal Unix-style path:

```bash
-v $(pwd)/bind-test:/data
```

may **fail silently**.

### Why

* Docker on Windows relies on Windows filesystem paths
* Git Bash returns Unix-style paths
* Docker does not always translate them correctly

### Correct approach on Windows

Use:

```bash
-v "$(pwd -W)/bind-test:/data"
```

This converts the path into a Windows-resolvable format.

### Key lesson

> Bind mounts are **host-OS sensitive**.

* Linux/macOS: paths work naturally
* Windows: path translation matters
* Named volumes hide this complexity because Docker manages the path

This is a major reason:

* Bind mounts are preferred in **development**
* Named volumes are safer in **production**

---

## 🔑 Core Truth Locked in Step 3

**Final sentence (operator-grade):**

> **Bind mounts persist data because they are a direct mapping to the host filesystem, not because Docker stores the data.**

---

## 🧠 What This Step Cemented

1. Bind mounts are **literal host folders**
2. Docker does not own or protect bind-mounted data
3. Persistence comes from the host, not Docker
4. Two-way visibility is immediate and mechanical
5. OS differences matter with bind mounts

---

## ⚖️ Bind Mount vs Named Volume (Intuition Level)

| Aspect           | Bind Mount    | Named Volume  |
| ---------------- | ------------- | ------------- |
| Storage owner    | Host          | Docker        |
| Visibility       | Fully visible | Mostly hidden |
| OS sensitivity   | High          | Low           |
| Dev friendliness | Very high     | Medium        |
| Prod safety      | Lower         | Higher        |

---

## ✅ Step 3 Completion Criteria

* Two-way data sync proven
* Container deletion tested
* Host-level persistence understood
* OS-specific nuance learned

**Step 3: COMPLETE**
