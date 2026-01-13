# 📅 Day 7 — Full System Rebuild, CI Ownership & Failure Resilience

> **Theme:** Ownership under uncertainty
> **Focus:** Rebuilding everything from scratch, breaking it intentionally, and understanding *why* each component behaves the way it does.

---

## 🎯 Day 7 Objective

By the end of Day 7, the goal was to confidently say:

> **“From a blank Linux VM, I can rebuild a Dockerized app, automate builds with CI, deploy it to the cloud, make it resilient to failures, and explain every moving part without notes.”**

Day 7 was **not about speed**.
It was about **calm execution without relying on memory, templates, or tutorials**.

---

## 🧱 Step 1 — Zero-State Reset (Intentional Discomfort)

I intentionally started from a **clean baseline**:

* Fresh Ubuntu EC2 VM
* No Docker images or containers
* No existing Git configuration
* No copied configs or notes

This was done on purpose.

> If a system feels comfortable immediately, it means I’m relying on habit — not understanding.

The discomfort at the start was the signal that learning was real.

---

## 🐧 Step 2 — Linux + Docker Rebuild (Foundation Layer)

### What I did

* Connected to EC2 using SSH with a `.pem` key
* Updated system packages
* Installed Docker from scratch
* Verified Docker daemon status
* Encountered **permission denied** while running Docker
* Fixed Docker permissions by adding my user to the `docker` group
* Reconnected to the VM to apply group changes
* Verified Docker works **without sudo**

### What I learned

* Docker permissions are purely **Linux group permissions**, not Docker magic
* `usermod -aG docker user` does nothing until the user session is restarted
* If Docker requires `sudo`, the system is not production-ready
* Docker daemon is just another Linux service managed by `systemd`

> Docker problems are usually Linux problems.

---

## 🧱 Step 3 — App + Dockerfile (Built From Memory)

### The App

I created a **simple shell-based app** that:

* Prints startup logs
* Runs as a long-lived process
* Can be intentionally crashed
* Produces clean, readable logs

This avoided `hello-world` intentionally — the app needed to behave like a **real service**, not a demo.

### Problems I Faced

* Incorrect shebang (`#!bin/bash` instead of `#!/bin/bash`)
* Script not executable (`permission denied`)
* Container failing to find `app.sh`
* Confusion between host filesystem vs container filesystem

### Fixes Applied

* Corrected shebang
* Explicit `chmod +x app.sh` inside Dockerfile
* Explicit `WORKDIR /app`
* Correct JSON-form `CMD ["./app.sh"]`

### Key Learning

> Containers don’t fail mysteriously — they fail because Linux rules are violated.

Docker did exactly what I told it to do. The bugs were in my assumptions.

---

## 🔄 Step 4 — CI Pipeline (GitHub Actions From Memory)

### What I Built

* Created `.github/workflows/ci.yml` manually
* CI triggers on every `push`
* CI performs:

  * Fresh repo checkout
  * Docker image build

No deployment inside CI — **build only**.

### What I Observed

* GitHub Actions runners are **fresh Linux VMs** every time
* No cached state
* No Docker images
* CI logs feel exactly like debugging on a real server

### Mental Model Locked

> CI is just automation running on a clean Linux machine.

CI ≠ CD.

---

## 🔐 Git + SSH — Pushing Code from EC2 to GitHub (DETAILED)

This was the **most important new learning** of Day 7.

### The Problem I Faced

* Git was installed correctly
* SSH key was generated correctly
* GitHub accepted the SSH key
* `git push` **still failed**

Error seen:

```
fatal: Authentication failed for 'https://github.com/...'
```

### Root Cause (Critical Understanding)

Git **was still using HTTPS**, not SSH.

* SSH keys **do not work** with HTTPS remotes
* GitHub has disabled password authentication for HTTPS
* As long as the remote URL is HTTPS, SSH keys are ignored

> SSH keys existing ≠ Git using SSH

The remote URL decides everything.

---

### Correct End-to-End Process (From Scratch)

#### 1️⃣ Install Git on EC2

```bash
sudo apt update
sudo apt install git -y
git --version
```

#### 2️⃣ Configure Git Identity

```bash
git config --global user.name "YourName"
git config --global user.email "your@email.com"
```

#### 3️⃣ Generate SSH Key on EC2

```bash
ssh-keygen -t rsa -b 4096 -C "your@email.com"
```

* Press Enter for default location
* Optional passphrase (can be empty for servers)

#### 4️⃣ Add SSH Key to GitHub

```bash
cat ~/.ssh/id_rsa.pub
```

* Copy the full output
* GitHub → Settings → SSH and GPG Keys **OR** Repo → Deploy Keys
* Paste key and save

#### 5️⃣ Verify SSH Authentication

```bash
ssh -T git@github.com
```

Expected output:

```
Hi username/repo! You've successfully authenticated, but GitHub does not provide shell access.
```

This confirms:

* SSH works
* GitHub recognizes the key

#### 6️⃣ Switch Git Remote from HTTPS → SSH (MOST IMPORTANT STEP)

```bash
git remote -v
git remote set-url origin git@github.com:username/repo.git
git remote -v
```

You **must** see `git@github.com:` in the output.

#### 7️⃣ Push Code Successfully

```bash
git add .
git commit -m "message"
git push -u origin main
```

### Key Mental Models Learned

* SSH authentication depends on **remote URL type**
* Deploy keys are repo-scoped (good for servers)
* User SSH keys are reusable across repos
* `Everything up-to-date` is a success signal, not an error

---

## ☁️ Step 5 — Manual Deployment (Real CD)

### What I Did

* Pulled repo onto EC2
* Built Docker image manually
* Ran container in detached mode
* Verified logs
* Confirmed app survives SSH disconnect

### Why This Matters

If CI/CD disappears tomorrow, I can still deploy calmly.

---

## ♻️ Step 6 — Resilience via Restart Policies

### Restart Policies Tested

* `on-failure`
* `unless-stopped`

### Failure Scenarios Injected

* App crash (exit code ≠ 0)
* Docker daemon restart
* Full VM reboot

### Observations

* `on-failure` restarts only on crashes
* `unless-stopped` survives Docker + VM restarts
* Manual `docker stop` always overrides automation

> Docker provides execution recovery, not bug fixing.

---

## 💣 Step 7 — Failure Injection & Validation

I intentionally caused:

* App crashes
* Restart loops
* Docker daemon restarts
* VM reboots

Then verified:

* Container state
* Restart counts
* Logs
* Recovery behavior

> Confidence comes from breaking systems on purpose — not from seeing them work once.

---

## 🧠 Weak Areas Identified (Honest Assessment)

* **Docker networking & ports** — almost untouched
* **Docker Compose** — minimal hands-on experience
* **Shell / Bash** — only basic usage so far
* **Practice depth** — needs repetition, not theory

These are now **explicit focus areas**, not vague weaknesses.

---

## 🏁 Final State

**Day 7 Status: COMPLETE**

I am no longer following steps.
I am reasoning about systems.

If this VM is deleted tomorrow, I can rebuild everything — calmly, correctly, and without fear.
