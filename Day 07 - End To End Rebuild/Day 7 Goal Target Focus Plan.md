# 🔥 DAY 7 — JANUARY 13

## END-TO-END REBUILD (ZERO → RUNNING → RESILIENT)

---

## 🎯 DAY 7 GOAL (ABSOLUTE, NON-NEGOTIABLE)

By the end of today, you must be able to say:

> **“From a blank Linux VM, I can rebuild a Dockerized app, automate builds with CI, deploy it to the cloud, make it resilient to failures, and explain every moving part without notes.”**

If **any step feels fuzzy** → today exposes it.

---

## ⏱️ TIME COMMITMENT

**Total:** 5–6 hours

* **1 hr** → Zero-state reset
* **2 hrs** → Rebuild core system
* **1 hr** → Rebuild CI
* **1 hr** → Deploy + resilience
* **1 hr** → Failure injection + validation

---

## 🧠 RULES FOR DAY 7 (VERY IMPORTANT)

❌ No notes
❌ No copy-paste from old repos
❌ No tutorials

✅ Google allowed **only for syntax**, not steps
✅ You must think before typing

> **This is not practice. This is ownership.**

---

## 🧱 STEP 1 — ZERO-STATE RESET (START CLEAN)

You **MUST** reset to a clean baseline.

Do **at least one** of the following *(preferred order)*:

* Create a **new Ubuntu EC2 VM**
* **OR** completely wipe Docker state:

  * Stop containers
  * Remove images
  * Remove volumes
* **OR** create a **new GitHub repo**

**The point is:**

> You should feel slightly uncomfortable at the start.

---

## 🐧 STEP 2 — LINUX + DOCKER REBUILD (FOUNDATION)

From scratch, **without notes**:

* SSH into VM
* Install Docker
* Verify Docker daemon
* Fix permissions (**no sudo dependency**)
* Confirm `docker run` works

> If this feels slow → **good**. Precision matters.

---

## 🧱 STEP 3 — APP + DOCKERFILE (FROM MEMORY)

You must:

* Create a **simple app** (shell or minimal service)
* Write a **Dockerfile from scratch**

Ensure the app has:

* A **long-running process**
* **Clean logs**
* **Correct permissions**

Then:

* Build the image
* Run the container successfully

❌ No `hello-world` cop-out
✅ It must resemble your **Day 5 app**

---

## 🔄 STEP 4 — CI PIPELINE (FROM MEMORY)

You must:

* Create `.github/workflows/ci.yml`
* Trigger CI **on push**
* Build Docker image **inside CI**

Force deliberately:

* One **failure**
* One **fix**

You must observe:

* Fresh runner
* Clean workspace
* Logs identical to Linux debugging

> If CI breaks → **fix it properly**, not blindly.

---

## ☁️ STEP 5 — DEPLOY TO VM (REAL CD)

From memory:

* Pull repo onto VM
* Build **or** pull Docker image
* Run container in **detached mode**
* Expose ports
* Verify accessibility
* Confirm it survives **SSH exit**

⚠️ No CI → CD automation yet — **manual CD only**

---

## ♻️ STEP 6 — RESILIENCE LAYER (MANDATORY)

You must:

* Apply a **restart policy**
* Kill container → observe recovery
* Restart Docker → observe recovery
* Reboot VM → observe recovery

Then answer honestly:

* What recovered automatically?
* What didn’t?
* Why?

> If something doesn’t recover → **fix it**.

---

## 💣 STEP 7 — FAILURE INJECTION (FINAL TEST)

Intentionally simulate:

* App crash
* Docker daemon restart
* VM reboot

Then:

* Verify system state
* Read logs
* Confirm restart behavior
* Detect crash loops (if any)

> This is where confidence is earned.

---

## 📝 FINAL DAY-7 CHECK (WRITE THIS)

Before stopping for the day, write short answers:

* Which step felt **weakest** today?
* What took **longest** to recall?
* What do I now **trust myself** to do without fear?
* If someone deleted my system tomorrow, could I rebuild it?

Be honest. **This determines what comes next.**

---

## ⚠️ MENTOR WARNING (IMPORTANT)

Day 7 is **not about speed**.
It is about **calm execution under uncertainty**.

* If you feel **tired but clear** → perfect
* If you feel **fast but shaky** → slow down and redo

---

## 🏁 END CONDITION

Day 7 is complete **only if**:

* You rebuilt everything **without notes**
* You broke and recovered the system
* You can explain **why each part behaves the way it does**
