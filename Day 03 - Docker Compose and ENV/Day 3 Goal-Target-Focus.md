# 📅 Day 3 — Docker Compose, ENV & Systems Thinking

**Date:** January 9
**Focus:** Docker Compose, multi-container systems, environment variables, networking, and dependency readiness
**Environment:** Ubuntu EC2 (terminal-only, no GUI, Docker + Docker Compose installed manually)

---

## 🎯 Objective for the Day

The goal for Day 3 was **not** to learn Docker Compose syntax.

The real objective was to move from:

> *“I can run containers”*
> to
> *“I can reason about and operate a multi-container system.”*

By the end of the day:

* Containers should **not feel isolated**
* Configuration should feel **external and controllable**
* Failures should feel **explainable and expected**
* Docker Compose should feel **mechanical, not magical**

If containers still felt like independent tools instead of system components, the day would be considered a failure.

---

## 🧠 Mental Models Established

Before writing any Compose files, I locked in the following distinctions.

### Dockerfile ≠ docker-compose.yml

* **Dockerfile** → Builds a **single image**
* **docker-compose.yml** → Orchestrates **multiple containers**

Dockerfiles define *how a container is built*.
Compose defines *how containers run together as a system*.

---

### Service ≠ Container (but always results in one)

* A **service** is a container runtime definition
* Every service results in a **container**
* Services are not abstract concepts — they are concrete container configurations

This corrected an important misconception.

---

### Build Time ≠ Runtime (Extended)

From Day 2:

* Code copied during build does **not change** unless rebuilt

New on Day 3:

* **ENV variables change behavior at runtime**
* Behavior can change **without rebuilding images**

This clarified *where* changes belong.

---

## 🧱 Hour 1 — Compose Mental Model (No Execution)

Before touching files, I internalized:

* Compose orchestrates containers — it does not replace Docker
* Networks are created automatically
* Service names become **DNS hostnames**
* `localhost` inside a container refers to **itself**
* Ports are for **host ↔ container**, not container ↔ container

This mental grounding prevented blind trial-and-error later.

---

## 🧱 Hour 2 — Services in Isolation

* Built **Service A** and **Service B** as standalone containers
* Wrote shell-based apps (`app.sh`, `server.sh`)
* Built images manually
* Ran containers individually

Problems faced and fixed:

* Docker daemon permission issues (`sudo`)
* Script execution issues inside images

This ensured each container worked **independently** before orchestration.

---

## 🧱 Hour 3 — Docker Compose Introduction

What I did:

* Installed Docker Compose manually (standalone binary)
* Wrote `docker-compose.yml` from scratch
* Defined multiple services using `build`
* Started and stopped the system using:

  * `docker-compose up`
  * `docker-compose up -d`
  * `docker-compose ps`
  * `docker-compose down`

Key realization:

> Compose creates a shared network and DNS automatically — containers now behave like a system.

This was the point where containers stopped feeling isolated.

---

## 🌍 Hour 4 — Environment Variables (Critical Learning)

This hour removed major real-world confusion.

### What I learned by breaking things:

* Editing application code does **nothing** unless the image is rebuilt
* Editing ENV values changes behavior **without rebuilding**
* Leaving `environment:` empty causes **YAML validation errors**
* Misplacing `env_file` causes **schema errors**
* ENV issues can fail:

  * at config-validation time
  * or at runtime — very different failure modes

I used:

* Inline `environment`
* `.env` files via `env_file`

This hour made configuration feel **deliberate and controllable**, not accidental.

---

## 🔌 Hour 5 — Systems Thinking (depends_on & Readiness)

This was the most important hour of the day.

### Key realization:

> **`depends_on` guarantees start order, not readiness.**

To prove this, I:

* Simulated a slow-starting dependency
* Used a file-based readiness signal
* Observed a dependent service start **before** the dependency was ready
* Saw the dependent service fail even though `depends_on` was present

This removed a dangerous misconception:

> “If I use `depends_on`, my system will work.”

It won’t — unless readiness is handled explicitly.

---

## 🧪 Tests & Validation

### Theory Test

* Took a full theory test
* Identified gaps in:

  * Dockerfile vs Image vs Container precision
  * Meaning of `localhost` inside containers
  * Role of ports in networking
  * False-positive health checks
* Corrected all gaps with focused notes

---

### Practical Rebuild-from-Memory Test

* Created a **new directory**
* Built a multi-container system from scratch
* Intentionally caused dependency failure
* Fixed the system by changing logic, not Compose
* Verified correct behavior

This confirmed **real understanding**, not memorization.

---

## 🔑 Key Lessons Locked In

* Containers are **parts of a system**, not standalone tools
* Networking is automatic, but assumptions are dangerous
* ENV controls behavior without rebuilds
* Images are static; containers are dynamic
* `depends_on` ≠ readiness
* Passing checks can be worse than failing ones if they’re wrong

---

## ✅ End-of-Day Reflection

By the end of Day 3, I can confidently say:

> **I understand how Docker Compose orchestrates multi-container systems, how containers communicate, how environment variables control runtime behavior, and why startup order is not the same as readiness. I can build, break, debug, and reason about containerized systems instead of treating them as black boxes.**

Day 3 was completed successfully.
