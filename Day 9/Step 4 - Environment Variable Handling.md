# ⚙️ Day 9 — Step 4: Environment Variable Handling (Runtime Configuration)

**Date:** January 15
**Theme:** Environment variables as runtime configuration (not build-time)
**Goal:** Prove that system behavior can change without rebuilding images or modifying application code

---

## 🎯 Why Step 4 Exists

Most Docker beginners misunderstand **where configuration belongs**.

They either:

* Hardcode values inside Dockerfiles ❌
* Bake environment-specific behavior into images ❌
* Rebuild images for simple config changes ❌

Step 4 exists to **lock in the correct DevOps mental model**:

> **Images are immutable. Configuration is injected at runtime.**

If this step is not crystal clear, real deployments become slow, fragile, and error‑prone.

---

## 🧠 Mental Model (Must Be Memorized)

```
Dockerfile  → build-time (static)
Image       → reusable artifact
ENV         → runtime behavior (dynamic)
Compose     → wiring + runtime config
```

ENV is:

* ❌ Not code
* ❌ Not build logic
* ✅ Runtime configuration

---

## 🧩 Starting Baseline (Working System)

At the start of Step 4, the system was already stable after Step 3 fixes.

### docker-compose.yml (inline ENV version)

```yaml
services:
  service-a:
    image: nginx
    ports:
      - "8080:80"

  service-b:
    image: curlimages/curl
    environment:
      TARGET_URL: http://service-a:80
    command:
      - sh
      - -c
      - |
        sleep 5
        if [ -z "$TARGET_URL" ]; then
          echo "ERROR: TARGET_URL not set"
          exit 1
        fi
        curl "$TARGET_URL"
```

### Behavior

* Service A: running nginx
* Service B: waits, reads ENV, calls Service A, exits successfully
* Browser access: `http://localhost:8080` works

---

## 🔁 STEP 4A — Move ENV to `.env` File

### 🎯 Purpose

To prove that **configuration can live outside Compose and code**, enabling:

* Environment-specific behavior
* Safer deployments
* No image rebuilds

---

### 🛠️ Action Taken

#### 1️⃣ Created a `.env` file

```env
TARGET_URL=http://service-a:80
```

#### 2️⃣ Removed `environment:` from `docker-compose.yml`

Service B after change:

```yaml
service-b:
  image: curlimages/curl
  command:
    - sh
    - -c
    - |
        sleep 5
        if [ -z "$TARGET_URL" ]; then
          echo "ERROR: TARGET_URL not set"
          exit 1
        fi
        curl "$TARGET_URL"
```

> Docker Compose automatically loads `.env` from the project directory.

---

### ▶️ Command Used

```bash
docker compose up
```

---

## ❌ Unexpected Failure Encountered (Important Learning)

### What Happened

* `.env` existed and was correct
* Docker Compose loaded ENV successfully
* Service B **still failed** with:

```
Failed to connect to service-a port 80
```

---

### Root Cause (Correctly Identified)

This was **NOT** an ENV problem.

The real cause:

* The earlier readiness delay (`sleep 5`) had been removed
* Service B ran before nginx finished starting

This reintroduced a **timing / readiness failure**.

---

## 🔐 Critical Insight (Key Step 4 Learning)

> **ENV handling and service readiness are orthogonal concerns.**

ENV determines *what* a service talks to.
Readiness determines *when* it can talk.

Solving one does not solve the other.

---

## 🔧 Fix — Restore Readiness Without Touching ENV

Service B was updated to reintroduce delay:

```yaml
service-b:
  image: curlimages/curl
  command:
    - sh
    - -c
    - |
        sleep 5
        if [ -z "$TARGET_URL" ]; then
          echo "ERROR: TARGET_URL not set"
          exit 1
        fi
        curl "$TARGET_URL"
```

### What Was NOT Changed

* `.env` file ❌
* Dockerfile ❌
* Image ❌

---

### ▶️ Command Used

```bash
docker compose up
```

---

## ✅ Result After Fix

* Service B successfully fetched nginx HTML
* Service A stayed running
* Browser access continued to work
* No image rebuild occurred

System behavior was **predictable and boring** again.

---

## 🔁 STEP 4B — Change Behavior Without Rebuild

### 🎯 Purpose

To prove that **only configuration** can change behavior.

---

### 🛠️ Action Taken

Modified `.env` only:

```env
TARGET_URL=http://service-a:80/does-not-exist
```

No YAML or code changes.

---

### ▶️ Command Used

```bash
docker compose up
```

---

### 👀 Observation

* Docker behavior unchanged
* Containers started normally
* Service B behavior changed
* Different HTTP response returned

---

## 🧠 Core DevOps Principles Locked in Step 4

### 1️⃣ ENV Belongs to Runtime

Hardcoding configuration in images:

* Forces rebuilds
* Breaks reuse
* Slows deployments

---

### 2️⃣ Images Are Immutable

The same image should run in:

* Dev
* QA
* Staging
* Prod

Only ENV changes.

---

### 3️⃣ Compose Loads `.env` Automatically

* No explicit reference required
* Makes config external and portable

---

### 4️⃣ Config Changes ≠ Structural Changes

Changing ENV:

* Does NOT change system wiring
* Does NOT rebuild images
* Only affects runtime behavior

---

## ✅ Step 4 Completion Criteria (Met)

* ENV moved out of Compose
* Runtime config proven
* No rebuilds performed
* Timing vs config separation understood

---

⛔ These notes should be revisited before real deployments to avoid baking configuration into images.
