# 🧱 Day 9 — Step 2: Build One Real Docker Compose System

**Date:** January 15
**Theme:** Docker Compose mechanics through one minimal, real system
**Goal:** Make Docker Compose behavior predictable, boring, and mechanical

---

## 🎯 Why Step 2 Exists

Step 2 is the **first contact between mental model and reality**.

Until this step:

* Everything was reasoning
* No YAML
* No containers

In this step:

* We deliberately built the **smallest real multi-container system**
* We proved Docker Compose networking, ports, and startup behavior
* We encountered our **first real-world distributed-system failure**

This step is meant to **remove fear**, not add features.

---

## 🧩 The System We Built

A deliberately boring system:

### Service A — HTTP Server

* Image: `nginx`
* Long-running process
* Listens on port `80` **inside the container**
* Exposed to the host using a published port

### Service B — Client / Worker

* Image: `curlimages/curl`
* Short-lived container
* Makes a single HTTP request to Service A
* Exits after completing its task
* Never exposed to the host

No databases. No volumes. No CI. No cloud.

---

## 🛠️ Step-by-Step: What Was Done

### Step 2A — Fresh Environment

* Created a brand-new directory
* Ensured no leftover files or configs
* Avoided reusing old Compose setups

**Reason:** Prevent hidden state from influencing behavior.

---

### Step 2B — Tool Choice (Intentional)

* Chose **nginx** as Service A
* Treated nginx as a **black box HTTP server**
* Did **not** learn nginx internals

**Why this matters:**

> DevOps often wires systems you didn’t write.

Understanding behavior > understanding implementation.

---

### Step 2C — Define Service A Only

Initial `docker-compose.yml`:

```yaml
services:
  service-a:
    image: nginx
    ports:
      - "8080:80"
```

**Key concepts locked here:**

* `ports:` is for **host ↔ container** traffic
* Format is always `host_port:container_port`
* Container listens on its internal port regardless of host mapping

No Service B yet. The system was intentionally incomplete.

---

### Step 2D — Predict → Run → Verify (Service A)

Before running:

* Predicted number of containers
* Predicted runtime behavior
* Predicted browser access result

After running:

* `service-a` container stayed **running**
* Browser access to `http://localhost:8080` succeeded
* nginx welcome page loaded exactly as predicted

**Important realization:**

> A system can be *correct* and still *incomplete*.

---

### Step 2E — Add Service B (Internal Client)

Updated `docker-compose.yml`:

```yaml
services:
  service-a:
    image: nginx
    ports:
      - "8080:80"

  service-b:
    image: curlimages/curl
    command: ["curl", "http://service-a:80"]
```

**Critical rules applied:**

* Service B uses **service name**, not localhost
* No `ports:` for Service B
* Internal Docker DNS used automatically

---

## ❌ The Failure Encountered (Very Important)

### What Happened

* `service-a` container: **running**
* `service-b` container: **exited**
* Error message:

  ```
  curl: (7) Failed to connect to service-a port 80
  Could not connect to server
  ```

Docker did **not** crash.
Networking existed.
DNS resolution worked.

---

### Why This Failure Happened (Root Cause)

This was **not** a networking problem.

The real cause:

1. Docker Compose started both containers
2. nginx process was still initializing
3. Service B executed immediately
4. nginx was not listening yet
5. Connection attempt failed

**Key distinction learned:**

> Container started ≠ Service ready

---

## 🛠️ Diagnostic Fix (Intentional, Temporary)

Service B was modified to include a delay:

```yaml
service-b:
  image: curlimages/curl
  command: ["sh", "-c", "sleep 5 && curl http://service-a:80"]
```

After re-running:

* Service B successfully fetched nginx HTML
* Service B exited cleanly
* Service A remained running

---

## 🧠 Core Concepts Proven in Step 2

### 1️⃣ Docker Compose Networking Is Predictable

* One default network created automatically
* Services discover each other by name
* No manual networking required

---

### 2️⃣ Ports Are NOT Needed for Container-to-Container Traffic

* Internal traffic ignores `ports:`
* Published ports exist only for host access

---

### 3️⃣ Startup Order ≠ Readiness

Docker Compose guarantees:

* Containers are started
* DNS is available

Docker Compose does NOT guarantee:

* Application readiness

This applies to:

* Docker
* Kubernetes
* ECS
* Systemd

---

### 4️⃣ Failure Classification Matters

| Failure Type | Example            | Docker Status |
| ------------ | ------------------ | ------------- |
| DNS error    | Wrong service name | Docker OK     |
| Timing issue | App not ready      | Docker OK     |
| App crash    | Bad config         | Docker OK     |

Docker is rarely the problem.

---

## 🔐 Mental Models to Reuse in the Future

* Treat services as **black boxes** first
* Predict behavior before running commands
* Observe logs before changing configs
* Fix the **smallest possible thing** first

Repetition builds instinct.

---

## ✅ Step 2 Completion Criteria (Met)

* Multi-container system built from scratch
* Internal networking proven
* Real-world timing failure experienced
* Failure reason understood, not guessed
* Fix applied deliberately

At this point, Docker Compose should already feel **less magical**.

---

⛔ These notes are designed to be revisited weeks later for confidence rebuilding.
