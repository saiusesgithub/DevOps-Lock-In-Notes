# Day 3 — Theory Test Gaps & Correct Mental Models

This document captures **only the concepts you missed or answered partially** in the Day 3 theory test, along with the **correct mental models** and **just enough context** to lock them in.

---

## 1. Dockerfile vs docker-compose.yml (Precision Fix)

### Your mistake

> “A Dockerfile is used to create a container.”

### Correct model

* **Dockerfile builds an IMAGE**
* A **container is created from an image**
* Docker Compose may:

  * build images using Dockerfiles, or
  * use prebuilt images directly

### Why this matters

Confusing *image* and *container* causes:

* unnecessary rebuilds
* wrong debugging layer (build-time vs run-time)

**One-liner to remember:**

> Dockerfile → Image → Container

---

## 2. What `docker-compose up` Actually Does (Missing Pieces)

### You mentioned

* Builds image if missing
* Creates a default network

### What you missed

When you run `docker-compose up`, Compose:

1. Reads `docker-compose.yml`
2. Creates a **project-scoped network**
3. Builds images (if required)
4. **Creates containers**
5. **Starts containers**
6. Starts containers in `depends_on` order
7. Aggregates logs to one terminal

### Why this matters

Understanding this makes Compose feel **mechanical**, not magical.

---

## 3. What Is a Service? (Important Correction)

### Your answer

> “A service can be anything, not necessarily a container.”

### Correct model

* A **service is a container runtime definition**
* A service **always results in one or more containers**
* It is not abstract, external, or non-container

### Example

```yaml
services:
  db:
    image: postgres
```

`db` is a **service**, and it runs a **Postgres container**.

---

## 4. `localhost` Inside a Container (Critical Fix)

### Your answer

> “localhost points to the host machine.”

### Correct model

* `localhost` inside a container points to **that same container**
* It does **not** point to:

  * the host
  * other containers

### Why this matters

This misconception is one of the **biggest beginner traps** in Docker.

**Correct rule:**

> `localhost` = current network namespace

---

## 5. Ports vs Container Networking (Clarity Improvement)

### What needed sharpening

You were correct but vague about ports.

### Correct model

* `ports:` are for **host ↔ container** traffic
* Containers talk to each other via:

  * Docker network
  * Service-name DNS
* Ports have **zero role** in container-to-container communication

---

## 6. Missed Question — “FAILED to reach Service B at localhost”

### Correct diagnosis

The mistake is:

* Using `localhost` instead of the **service name**

### Why it fails

* `localhost` points back to Service A
* Service B lives in a **different container**

**Correct fix:**

```text
Use service-b, not localhost
```

---

## 7. False-Positive Health Checks (Concept Expansion)

### What you partially got

* Passing checks can hide bugs

### Correct DevOps framing

A false-positive health check is dangerous because:

* It reports "OK" when the system is broken
* It hides real failures
* It delays detection and recovery

### Example from Day 3

* `ping localhost` passed
* But it proved **nothing** about dependency health

---

## 8. Missed Concept — The False-Positive You Almost Made

### The mistake

* Treating green logs / successful ping as proof the system worked

### Correct operator mindset

> Logs can lie if the check is wrong.

A failing check is often **more valuable** than a passing one.

---

## 9. One-Line Summary You Missed (Day 3 in One Sentence)

### Strong answer you should internalize

> Day 3 taught me that containers are parts of a system, and correctness depends on networking, configuration, and readiness—not just containers being "up".

---

## 10. Final Mental Models to Lock In

* Dockerfile builds **images**, not containers
* Services always run **containers**
* `localhost` inside a container = itself
* Service names = DNS hostnames
* Ports ≠ internal networking
* ENV controls behavior without rebuilds
* `depends_on` ≠ readiness
* A passing check can still be wrong

---

## Status

These gaps are now **closed**.

You now have:

* correct terminology
* correct layering
* operator-level mental models

✅ **Day 3 theory gaps resolved**
