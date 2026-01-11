# Docker Permissions on Linux — Using Groups (Avoiding sudo)

> This note explains **why Docker requires sudo by default**, how Linux permissions work around the Docker daemon, and **the correct, production-grade way** to run Docker without sudo.

---

## 1. Why `sudo docker` Works (and `docker` Doesn’t)

Docker is split into **two parts**:

1. **Docker Client (`docker`)**

   * A CLI binary run by the user
   * Sends requests to the Docker daemon

2. **Docker Daemon (`dockerd`)**

   * Runs as **root**
   * Manages containers, images, networks

The client talks to the daemon via a **Unix socket**:

```
/var/run/docker.sock
```

This socket is **owned by root**.

---

## 2. The Core Problem

By default:

* Only **root** can access `/var/run/docker.sock`
* Normal users get:

```
permission denied while trying to connect to the Docker daemon socket
```

So:

* `docker ps` ❌
* `sudo docker ps` ✅

This is expected Linux behavior — **not a Docker bug**.

---

## 3. Why Always Using `sudo` Is Bad

Using `sudo docker`:

* Trains bad habits
* Hides permission issues
* Breaks scripts and automation
* Causes CI / deployment mismatches

In real deployments:

* Services
* Scripts
* Automation

**cannot rely on interactive sudo**.

---

## 4. The Correct Fix: Docker Group

Linux uses **groups** to share permissions.

Docker creates a group called:

```
docker
```

Members of this group are allowed to access:

```
/var/run/docker.sock
```

This is the **intended, official solution**.

---

## 5. Adding a User to the Docker Group

Command:

```bash
sudo usermod -aG docker <username>
```

Example:

```bash
sudo usermod -aG docker ubuntu
```

Explanation:

* `-a` → append (do NOT overwrite groups)
* `-G` → supplementary group

⚠️ Never omit `-a` — it can remove other group memberships.

---

## 6. Why Re-Login Is Mandatory

Linux group membership is loaded **at login time**.

That means:

* Existing SSH session ❌ does not update groups
* New SSH session ✅ applies new group

Correct options:

### Preferred

```bash
exit
# SSH again
```

### Temporary (session-only)

```bash
newgrp docker
```

For deployment realism, **re-SSH is better**.

---

## 7. Verifying the Fix

After re-login:

```bash
docker ps
docker run hello-world
```

Expected:

* No sudo
* No permission errors

If it works → VM is Docker-ready.

---

## 8. Security Implication (Important)

⚠️ **Being in the `docker` group ≈ root access**

Why?

* Docker can mount `/`
* Docker can run privileged containers

This is acceptable for:

* Dev VMs
* CI runners
* Controlled servers

But:

* Never add untrusted users

---

## 9. Deployment Takeaway

A deployable system must:

* Run Docker commands non-interactively
* Avoid sudo dependencies
* Rely on correct Linux permissions

If Docker only works with sudo → deployment is fragile.

---

### Status

* Permission issue: **understood**
* Fix applied: **group-based (correct)**
* VM readiness:
