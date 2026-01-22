# 🔐 EC2 ↔ GitHub Authentication using SSH (Deep Dive Notes)

> **Context:** These notes document my *first real experience* pushing code from an AWS EC2 Linux VM to GitHub using **SSH authentication**, including mistakes, failures, and the exact mental models I locked in.
>
> This is not a tutorial rewrite — this is an **operator-level explanation** of *what actually happens* and *why things break*.

---

## 🧠 Why Authentication from EC2 to GitHub is Non‑Trivial

From a local laptop, GitHub auth often feels invisible because:

* SSH keys already exist
* Git is preconfigured
* Browsers handle auth silently

On a **fresh EC2 VM**:

* No Git installed
* No SSH identity
* No trust relationship with GitHub

So **everything must be built manually**.

This is why Day 7 felt confusing — and why it was valuable.

---

## 🧱 High‑Level Flow (Mental Model)

Pushing code from EC2 → GitHub over SSH requires **ALL** of the following:

1. Git installed on EC2
2. Git user identity configured (name + email)
3. SSH key pair generated on EC2
4. Public key trusted by GitHub
5. Git remote URL using **SSH**, not HTTPS
6. SSH agent able to present the key

If **any one** of these is wrong → auth fails.

---

## 🐧 Step 1 — Install Git on EC2

```bash
sudo apt update
sudo apt install git -y
git --version
```

### Why this matters

* EC2 images are minimal by design
* Git is not guaranteed to exist
* Without Git, SSH keys alone are useless

---

## 👤 Step 2 — Configure Git Identity

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### What this does

* Sets **commit metadata**, not authentication
* Commits will fail or look broken without this

⚠️ This does **NOT** authenticate you to GitHub.

---

## 🔑 Step 3 — Generate SSH Key Pair on EC2

```bash
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
```

Press **Enter** for:

* Default file location: `~/.ssh/id_rsa`
* Empty passphrase (acceptable for servers)

### What just happened (important)

* A **private key** was created → stays on EC2
* A **public key** was created → meant to be shared

```bash
ls ~/.ssh
# id_rsa  id_rsa.pub
```

---

## 🔓 Step 4 — Add Public Key to GitHub

Display the public key:

```bash
cat ~/.ssh/id_rsa.pub
```

Copy the full line starting with:

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ...
```

### Two places you can add this key (CRITICAL DIFFERENCE)

#### Option A — **Deploy Key** (what I used)

* Added inside **Repo → Settings → Deploy Keys**
* Scope: **this repo only**
* Shows auth message like:

```
Hi saiusesgithub/day7! You've successfully authenticated
```

✅ Good for servers & CI
❌ Not reusable across repos

#### Option B — **User SSH Key**

* GitHub → Settings → SSH and GPG keys
* Scope: **all repos for this user**

```
Hi saiusesgithub! You've successfully authenticated
```

---

## 🧪 Step 5 — Test SSH Auth (MANDATORY)

```bash
ssh -T git@github.com
```

Expected output:

```text
Hi <identity>! You've successfully authenticated, but GitHub does not provide shell access.
```

### Why this matters

* This confirms **SSH works independently of Git**
* If this fails → Git will never work

---

## 🚨 The Core Day‑7 Failure (HTTPS vs SSH)

### What went wrong

Even after SSH keys were correct, Git kept failing with:

```text
fatal: Authentication failed for 'https://github.com/...'
```

### Root cause (IMPORTANT)

* SSH keys **do not work with HTTPS URLs**
* Git was still using:

```text
https://github.com/username/repo.git
```

GitHub **disabled password auth**, so this will *always fail*.

---

## 🔁 Step 6 — Fix the Remote URL (THE KEY UNLOCK)

Check current remote:

```bash
git remote -v
```

If you see HTTPS → it’s wrong.

Fix it:

```bash
git remote set-url origin git@github.com:username/repo.git
```

Verify:

```bash
git remote -v
```

Expected:

```text
origin  git@github.com:username/repo.git (fetch)
origin  git@github.com:username/repo.git (push)
```

This **single command** fixed everything.

---

## 🚀 Step 7 — Push from EC2 to GitHub

```bash
git push -u origin main
```

If SSH is correct:

* No password prompt
* No browser popup
* Clean push

```text
Everything up-to-date
```

This is **success**, not an error.

---

## 🧠 Key Mental Models Learned (Critical)

### 1️⃣ SSH keys don’t authenticate Git by themselves

You need:

* SSH key ✅
* GitHub trust ✅
* **SSH remote URL** ✅

Miss one → auth fails.

---

### 2️⃣ HTTPS and SSH are completely different auth systems

| Method | Uses             | Works with SSH keys |
| ------ | ---------------- | ------------------- |
| HTTPS  | username + token | ❌                   |
| SSH    | key‑based auth   | ✅                   |

You cannot mix them.

---

### 3️⃣ Deploy key identity matters

This message:

```text
Hi saiusesgithub/day7!
```

Means:

* You authenticated as a **deploy key**
* Scoped only to that repo
* Expected and correct

---

### 4️⃣ Git errors are precise — not vague

Git was telling the truth the whole time:

```text
fatal: Authentication failed for 'https://...'
```

The mistake was **reading past it too fast**.

---

## 🏁 Final End‑State Checklist (Gold Standard)

```bash
ssh -T git@github.com
# success message

git remote -v
# shows git@github.com

ls -a
# .git  .github  Dockerfile  app.sh  README.md

git status
# clean
```

If all of this is true → EC2 ↔ GitHub auth is **correct and stable**.

---

## 🧩 Why This Matters for DevOps

This knowledge directly applies to:

* CI runners
* Production servers
* GitOps workflows
* Disaster recovery rebuilds

If a laptop dies or a VM is wiped — this process lets me recover calmly.

---

✅ **This is now a locked‑in skill, not tribal knowledge.**
