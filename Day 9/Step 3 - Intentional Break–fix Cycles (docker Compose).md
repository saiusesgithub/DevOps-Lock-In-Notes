# 🔁 Day 9 — Step 3: Intentional Break–Fix Cycles (Docker Compose)

**Date:** January 15
**Theme:** Failure-driven learning with Docker Compose
**Goal:** Make Docker Compose behavior predictable, mechanical, and calm under failure

---

## 🎯 Why Step 3 Exists

Step 3 exists to **kill panic**.

Most people "learn" Docker Compose only in the happy path. That creates fear when something breaks.

This step intentionally:

* Breaks the system in *controlled ways*
* Forces prediction before execution
* Trains failure classification instead of guessing

By the end of this step:

> Docker Compose should feel **boring**, not magical.

---

## 🧩 Base System (Before Breaking)

This is the **stable baseline** used for all breaks.

```yaml
services:
  service-a:
    image: nginx
    ports:
      - "8080:80"

  service-b:
    image: curlimages/curl
    command: ["sh", "-c", "sleep 5 && curl http://service-a:80"]
```

### System behavior (baseline)

* Service A: long-running nginx server
* Service B: waits, calls Service A, exits
* Host access: `http://localhost:8080` works
* Internal networking: service name resolution works

---

## 🧠 Mental Rule Applied Throughout Step 3

> **Predict → Observe → Classify → Fix (smallest possible change)**

No guessing. No random edits.

---

# 🧨 BREAK #1 — Wrong Service Name (Step 3B)

### 🎯 What This Tests

* Docker internal DNS
* Service name resolution
* Runtime vs startup failures

---

### 🔧 Intentional Break

Changed Service B to call a **non-existent service name**:

```yaml
service-b:
  image: curlimages/curl
  command: ["sh", "-c", "sleep 5 && curl http://service-aa:80"]
```

---

### ▶️ Command Used

```bash
docker compose up
```

---

### 👀 Observation

* service-a: **running**
* service-b: **exited**
* Error message:

  ```
  Could not resolve host: service-aa
  ```

---

### 🧠 Failure Classification

| Aspect         | Result                |
| -------------- | --------------------- |
| Docker startup | Successful            |
| Networking     | Exists                |
| DNS            | ❌ Failed              |
| Failure type   | DNS / name resolution |

**User explanation (correct):**

> Service B couldn’t find `service-aa`.

---

### 🔧 Fix

Restored correct service name:

```yaml
curl http://service-a:80
```

---

# 🧨 BREAK #2 — Wrong Container Port (Step 3C)

### 🎯 What This Tests

* Container port vs host port
* Internal networking clarity

---

### 🔧 Intentional Break

Service B called the **host port** instead of container port:

```yaml
service-b:
  image: curlimages/curl
  command: ["sh", "-c", "sleep 5 && curl http://service-a:8080"]
```

---

### ▶️ Command Used

```bash
docker compose up
```

---

### 👀 Observation

* service-a: **running**
* service-b: **exited**
* Error message:

  ```
  Failed to connect to service-a port 8080
  ```

---

### 🧠 Failure Classification

| Aspect       | Result        |
| ------------ | ------------- |
| DNS          | Works         |
| Networking   | Works         |
| Port usage   | ❌ Wrong       |
| Failure type | Port mismatch |

**User explanation (correct):**

> Service A listens on 80 inside the container, not 8080.

---

### 🔧 Fix

Restored correct container port:

```yaml
curl http://service-a:80
```

---

# 🧨 BREAK #3 — Missing Port Mapping (Step 3D)

### 🎯 What This Tests

* Host ↔ container vs container ↔ container separation
* Purpose of `ports:`

---

### 🔧 Intentional Break

Removed `ports:` from Service A:

```yaml
service-a:
  image: nginx
```

Service B unchanged.

---

### ▶️ Command Used

```bash
docker compose up
```

---

### 👀 Observation

* service-a: **running**
* service-b: **success**
* Browser (`localhost:8080`): ❌ connection refused

---

### 🧠 Failure Classification

| Path                  | Result                     |
| --------------------- | -------------------------- |
| Container → container | ✅ Works                    |
| Host → container      | ❌ Fails                    |
| Failure type          | Missing host port exposure |

**User explanation (mostly correct):**

> Containers communicate internally via Docker’s default network; host access requires port publishing.

---

### 🔧 Fix

Restored port mapping:

```yaml
ports:
  - "8080:80"
```

---

# 🧨 BREAK #4 — Missing Environment Variable (Step 3E)

### 🎯 What This Tests

* Runtime configuration failures
* ENV vs Docker vs networking failures

---

### 🔧 Intentional Break

Service B was modified to **require** an environment variable:

```yaml
service-b:
  image: curlimages/curl
  command:
    - sh
    - -c
    - |
      if [ -z "$TARGET_URL" ]; then
        echo "ERROR: TARGET_URL not set"
        exit 1
      fi
      curl "$TARGET_URL"
```

No `environment:` provided.

---

### ▶️ Command Used

```bash
docker compose up
```

---

### 👀 Observation

* service-a: **running**
* service-b: **exited**
* Output:

  ```
  ERROR: TARGET_URL not set
  ```

---

### 🧠 Failure Classification

| Aspect       | Result                         |
| ------------ | ------------------------------ |
| Docker       | Works                          |
| Networking   | Works                          |
| Ports        | Correct                        |
| Failure type | ❌ Missing ENV (runtime config) |

**User explanation (correct):**

> Service B expected a target URL but it was not configured.

---

### 🔧 Fix (Runtime Only)

```yaml
service-b:
  image: curlimages/curl
  environment:
    TARGET_URL: http://service-a:80
```

No image rebuild required.

---

## 🧠 Core DevOps Principles Locked in Step 3

### 1️⃣ Docker rarely causes failures

Most failures are:

* DNS
* Ports
* Timing
* Configuration

---

### 2️⃣ Container start ≠ Application ready

Readiness must be handled explicitly.

---

### 3️⃣ ENV is runtime configuration

Images stay reusable; behavior changes per environment.

---

### 4️⃣ Error messages tell you the fix

If you classify the error correctly, the fix is obvious.

---

## ✅ Step 3 Completion Criteria (Met)

* Multiple failure types experienced
* Each failure predicted and classified
* Fixes applied calmly and minimally
* Docker Compose behavior now predictable

---

⛔ These notes are meant to be revisited before real-world deployments to avoid panic-driven debugging.
