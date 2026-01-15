# 🧠 Day 9 — Step 1: Docker Compose Mental Reset (No Terminal)

**Date:** January 15
**Focus:** Mental model of Docker Compose systems before touching YAML or terminal

---

## 🎯 Purpose of This Step

This step exists to **eliminate magic thinking** around Docker Compose.

Before writing any `docker-compose.yml`, you must be able to:

* Describe the system **without tools**
* Predict behavior **before execution**
* Separate **Docker behavior** from **application behavior**

If this step is weak, Compose will always feel confusing later.

---

## 🧩 System Being Designed (Conceptual)

A deliberately **boring, minimal system**:

* **Service A** → Long-running HTTP API server
* **Service B** → Client/worker that calls Service A

No databases, no queues, no scaling. Just communication.

---

## ❓ Questions Asked (Mentor Prompts)

These questions must be answerable **without Docker or YAML**.

### 1️⃣ What services exist?

> Name them explicitly. No tools, no implementation details.

**Your answer:**

* Service A is a long always-running API server
* Service B calls / accesses Service A

**Correct & Locked-in Answer:**

* Service A: long-running HTTP server that listens and responds
* Service B: client/worker that sends requests to Service A

---

### 2️⃣ Who talks to whom?

> Draw arrows mentally.

Questions:

* Does Service A talk to Service B?
* Does Service B talk to Service A?
* Does the host talk to either?

**Your answer:**

* Service B sends a request to Service A
* Service A listens and responds
* Host doesn’t talk to either (initial assumption)

**Correct & Finalized Understanding:**

* Service B ➜ Service A (container → container)
* Service A ➜ nobody
* Host ➜ Service A (**required by Day 9 goals**)
* Host ➜ Service B ❌ (never needed)

This distinction determines `ports:` usage later.

---

### 3️⃣ Which traffic needs published ports?

**Key Rule (must memorize):**

* `ports:` = **host ↔ container** traffic
* Docker network = **container ↔ container** traffic

**Your answer:**

* If Service B is accessed by host, it needs ports
* Service A won’t need ports
* Container-to-container uses internal Docker network

**Correct & Locked-in Answer (for this system):**

* Service A → **needs `ports:`** (host must reach it)
* Service B → **does NOT need `ports:`**

> Internal Docker networking does NOT require ports.

This rule applies forever — databases, APIs, caches, workers.

---

### 4️⃣ How does Service B find Service A?

> This is the most critical Compose concept.

**Your answer:**

* Service B reaches Service A by service name

**Correct & Expanded Explanation:**

* Docker Compose creates an internal DNS
* Every service name becomes a resolvable hostname
* Service B connects to:

  ```
  http://<service-name>:<container-port>
  ```

❌ Never use:

* `localhost`
* Container IPs
* Host IPs

This is what makes Compose predictable and portable.

---

### 5️⃣ What breaks if the service name is wrong?

> Predict the failure before fixing it.

**Your answer:**

* Service B couldn’t find Service A
* Error like not reachable or 400 series
* Docker wouldn’t crash

**Correct Failure Classification:**

* ❌ Not HTTP 400/404 (those require a running server)
* Actual error types:

  * DNS resolution failure
  * `Could not resolve host`
  * `Name or service not known`

**Key Insight:**

* Containers **start successfully**
* Application fails **at runtime**
* Docker engine stays healthy

This distinction is crucial during debugging.

---

## 🧠 Core Mental Models (Save for Future Revision)

### 1️⃣ Docker Compose is NOT magic

Compose only:

* Starts containers
* Creates a shared network
* Registers service names in DNS

Everything else is **application behavior**.

---

### 2️⃣ Startup vs Runtime Failures

| Failure Type       | Example         | Docker Crashes? |
| ------------------ | --------------- | --------------- |
| Bad image          | Build error     | ❌ No container  |
| Bad command        | Container exits | ❌ Docker alive  |
| Wrong service name | DNS failure     | ❌ Docker alive  |
| App bug            | Runtime error   | ❌ Docker alive  |

Docker is rarely the problem.

---

### 3️⃣ Ports Are for Humans, Not Containers

* Containers don’t need ports to talk
* Humans (browsers, curl, Postman) do

If two services are both inside Compose:

> **Ports are optional, not default**

---

### 4️⃣ Why This Matters in Real Systems

This exact mental model applies to:

* API + database
* API + cache
* Worker + API
* Microservices
* Local dev environments
* Cloud deployments

If you understand this step:

* Debugging becomes reasoning
* Compose becomes boring
* Fear disappears

---

## ✅ Step 1 Completion Criteria

* System can be described without YAML
* Traffic flows are predictable
* Ports usage is intentional
* Failures are classified before running

This step must feel **obvious**, not impressive.

---

⛔ **Do NOT proceed unless this document makes sense on re-reading weeks later.**
