# 📅 Day 2 — Docker Core

**Date:** January 8
**Focus:** Docker fundamentals — images, containers, Dockerfiles, and debugging
**Environment:** Ubuntu EC2 (terminal-only, no GUI, no Docker Desktop)

---

## 🎯 Objective for the Day

The goal for Day 2 was **not** to memorize Docker commands, but to remove the *mystery* around Docker.

By the end of the day, Docker should feel:

* Predictable
* Mechanical
* Debuggable

If Docker still felt “cool” or “magical,” the day would be considered a failure.

---

## 🧠 Mental Models Established

Before touching commands, I locked in these foundational distinctions:

### Image ≠ Container

* **Image** → Read-only blueprint
* **Container** → Running instance of an image

An image can create multiple containers. Containers can stop and die; images persist.

---

### Dockerfile ≠ Image

* **Dockerfile** → Recipe (plain text instructions)
* **Image** → Result of building the Dockerfile

Changing a Dockerfile does nothing unless the image is rebuilt.

---

### Build Time ≠ Run Time

* `RUN` → Executes during **image build** (once)
* `CMD` / `ENTRYPOINT` → Execute during **container start** (every run)

This distinction removed most confusion around why Docker behaves the way it does.

---

## 🔧 Docker Setup (Real Linux Environment)

* Installed Docker manually on an Ubuntu EC2 instance
* Verified Docker daemon using `systemctl`
* Ran the `hello-world` container to confirm:

  * Docker daemon works
  * Image pulling works
  * Containers can run successfully

All Docker interaction was done via terminal using `sudo docker ...` (no Docker Desktop).

---

## 🧱 Dockerfile #1 — Minimal

**Goal:** Understand the absolute basics.

What I did:

* Created a minimal Dockerfile using only:

  * `FROM`
  * `CMD`
* Built the image manually
* Ran the container
* Observed that:

  * The container starts
  * `CMD` runs
  * The container exits immediately after the command finishes
* Deleted containers and images to understand lifecycle

This removed fear around Docker’s “black box” behavior.

---

## 🧱 Dockerfile #2 — Slightly Real

**Goal:** Move closer to real-world usage.

What I did:

* Created a shell script on the host using `nano`
* Made the script executable and tested it locally
* Wrote a Dockerfile that:

  * Installed dependencies at build time using `RUN`
  * Copied host files into the image using `COPY`
  * Ran the script using `CMD`

Key concepts learned:

* **Build context**: Docker can only access files inside the project directory
* Dependencies must be installed at build time
* Containers stop when the main process exits

---

## 💣 Dockerfile #3 — Intentionally Broken

**Goal:** Learn Docker by debugging real failures.

What I did:

* Wrote a Dockerfile that built successfully but failed at runtime
* Encountered a `permission denied` error when running the container
* Diagnosed the failure:

  * Build succeeded
  * Failure occurred at runtime
  * Root cause was missing execute permission **inside the image**
* Fixed the issue correctly by:

  * Adding `RUN chmod +x` in the Dockerfile
* Rebuilt the image and confirmed successful execution

This reinforced that most Docker errors are actually **Linux errors**.

---

## 🔧 Problems Faced & Fixed

* Faced errors due to **not using `sudo` while running Docker commands**
* Faced runtime failures due to **missing execute permission in the image**
* Identified both issues by carefully reading error messages
* Fixed both logically without trial-and-error or copy-pasting solutions

---

## 🔁 Final Rebuild-from-Memory Test

To validate learning:

* Created a new folder
* Wrote a Dockerfile and script from scratch
* Built the image
* Intentionally caused a failure
* Debugged and fixed it without notes

This confirmed real understanding rather than memorization.

---

## ✅ End-of-Day Reflection

By the end of Day 2, I can confidently say:

> **I understand what Docker is doing at build time vs run time, how images and containers differ, and why Dockerfiles behave the way they do. I can write Dockerfiles from scratch, build images, run containers, debug failures, and explain exactly what’s happening.**

Day 2 was completed successfully.