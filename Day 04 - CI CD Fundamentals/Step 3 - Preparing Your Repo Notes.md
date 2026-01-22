# 🗂️ STEP 3 — PREPARE YOUR REPO

## 1️⃣ What “preparing the repo” actually means

Preparing the repo does **not** mean:

* adding CI config
* enabling GitHub Actions
* writing YAML

Preparing the repo means:

> **Your project can be built and understood by a machine with zero context.**

CI does not think.
CI does not infer.
CI does not remember.

It only executes what exists in the repository.

---

## 2️⃣ How CI sees your project

You see your project with history:

* tools you installed earlier
* commands you ran manually
* environment variables you forgot about
* files that exist only on your laptop

CI sees your project as:

* a folder of files
* on a brand-new Linux machine

Nothing else exists.

If it is not in the repo, CI cannot see it.

---

## 3️⃣ Why CI is intentionally strict

CI is strict by design because:

* servers are clean
* production is unforgiving
* automation cannot guess intent

So when CI fails, it is usually telling the truth:

> *“This project is not fully defined yet.”*

This is a feature, not a flaw.

---

## 4️⃣ Docker as the build contract

Docker is ideal for CI because it forces clarity.

A Dockerfile answers this question:

> “Given a clean Linux system, what exact steps are required to build this?”

That makes Docker a **contract**:

* inputs: source files
* process: build steps
* output: image or failure

CI simply enforces this contract on every push.

---

## 5️⃣ What makes a repo CI-ready

A repo is CI-ready if **one** of these is true:

### Dockerfile-based repo

* `Dockerfile` exists
* `docker build .` works locally
* No interactive/manual steps

### docker-compose-based repo

* `docker-compose.yml` exists
* All services define build contexts
* `docker compose build` works locally

Nothing more is required.
Nothing less will work.

---

## 6️⃣ Common hidden assumptions CI exposes

CI often fails because of assumptions like:

* packages installed globally on your laptop
* scripts without execute permissions
* `.env` files that were never committed
* relative paths that only work locally
* commands that require interactive shells

CI exposes these because it starts from zero.

---

## 7️⃣ Why this step exists before CI config

Adding CI to a broken process only:

* speeds up failure
* increases noise
* creates confusion

The process must be deterministic **first**.
Automation comes after.

---

## 8️⃣ Mental checklist (lock this)

Before adding any CI pipeline, you should confidently say:

* A fresh Linux machine could build this repo
* No manual setup is required
* Docker fully defines the build
* If CI fails, the repo—not CI—is wrong

If this feels true, Step 3 is complete.
