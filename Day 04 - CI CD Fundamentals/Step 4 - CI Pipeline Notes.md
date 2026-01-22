# 🧠 STEP 4 — CI PIPELINE MENTAL MODEL (REFERENCE NOTES)

---

## 1️⃣ What a CI pipeline really is

A CI pipeline is **not**:

* a GitHub feature
* a YAML trick
* a DevOps buzzword

A CI pipeline **is**:

> **A written sequence of commands that a Linux machine runs automatically when an event happens.**

That’s it.

Everything else (YAML, UI, green checks) is just wrapping.

---

## 2️⃣ The event → machine → commands flow

Every CI run follows this exact lifecycle:

1. **Event happens**

   * e.g. `git push`

2. **CI system reacts**

   * GitHub notices the event

3. **Runner is created**

   * Fresh Linux machine (Ubuntu)

4. **Your pipeline file is read**

   * Instructions are parsed

5. **Commands are executed**

   * Top to bottom

6. **Result is reported**

   * Success ✅ or Failure ❌

If you can visualize this flow, CI stops being confusing.

---

## 3️⃣ Where the pipeline file fits

In GitHub Actions, the pipeline is defined by:

```
.github/workflows/ci.yml
```

This file answers four questions:

1. **When should this run?**
2. **On what machine should it run?**
3. **What steps should be executed?**
4. **What should cause failure?**

Nothing more.

---

## 4️⃣ Jobs: one machine, isolated environment

A **job** represents:

> **One isolated Linux machine running your steps**

Key properties:

* Each job gets its own fresh runner
* Jobs do not share state by default
* Jobs can run in parallel (later)

For now, think:

> One pipeline = one job = one machine

---

## 5️⃣ Steps: sequential commands

Inside a job are **steps**.

Each step:

* runs in order
* shares the same filesystem
* can affect the next step

Conceptually, steps are like:

```bash
command 1
command 2
command 3
```

If any command fails → job fails.

---

## 6️⃣ Two kinds of steps

### `uses:` steps

* Prebuilt actions
* Encapsulate common logic
* Example: checking out code

Think of them as:

> Scripts written by someone else

### `run:` steps

* Commands you write
* Executed by the shell
* This is where **your logic lives**

CI mastery comes from understanding `run:` steps.

---

## 7️⃣ Checkout is not optional

A fresh runner starts with:

* no source code
* empty working directory

So the first real step in most pipelines is:

> **“Download my repo onto this machine.”**

Without checkout:

* Dockerfile doesn’t exist
* scripts don’t exist
* builds fail instantly

---

## 8️⃣ Docker inside CI (conceptual view)

When CI runs Docker commands:

* Docker runs on the runner
* Exactly like local Docker
* Same build behavior
* Same errors

So:

> `docker build` in CI = `docker build` on Ubuntu

If it fails in CI, it would fail on a clean Linux box.

---

## 9️⃣ Failure is a design feature

CI pipelines are designed to **fail loudly**.

Failure means:

* a command returned non-zero
* assumptions were violated
* something changed unexpectedly

A red ❌ is **information**, not punishment.

---

## 🔟 What Step 4 is NOT about

Step 4 is **not** about:

* optimizing pipelines
* caching layers
* multi-job workflows
* deployment
* secrets

Those come later.

Right now, the only goal is:

> **Understand what is executed, where, and why it fails.**

---

## 1️⃣1️⃣ Mental checklist (lock this)

Before writing `ci.yml`, you should be able to say:

* A pipeline is commands executed on a Linux machine
* A job equals one isolated runner
* Steps run sequentially
* Checkout is required
* Failure comes from exit codes

If this feels obvious, Step 4 mental model is locked.

---
