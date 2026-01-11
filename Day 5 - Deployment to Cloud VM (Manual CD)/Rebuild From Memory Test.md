# Day 5 — Rebuild From Memory Test

## Final Deployment Validation (Commands + Test Instructions)

> This document records the **exact rebuild-from-memory test** executed at the end of Day 5. It is meant as a **future reference checklist**, not a tutorial.

---

## 🎯 Purpose of the Test

The rebuild-from-memory test exists to validate **true deployment ownership**.

The goal was to prove:

* Deployment can be reconstructed **without notes**
* Runtime state vs disk state is clearly understood
* Failures can be handled calmly using logs and Docker primitives

Passing this test marks **Day 5 as complete**.

---

## 🚫 Test Rules (As Enforced)

* Fresh local terminal
* Fresh SSH session
* No notes or previous commands referenced
* No automation
* No blind rebuilding
* Logs before decisions

Allowed:

* `docker logs`
* `docker ps`, `docker ps -a`
* Error messages

---

## 🧪 Test Questions (Mental Checklist)

Before acting, the following questions were answered mentally:

* Is Docker installed and running?
* Are any containers currently running?
* Does the image already exist?
* Does the repository exist on disk?
* What state is runtime vs disk?

---

## 🟢 Phase 0 — Clean Start

### Local Machine (SSH Setup)

```bash
cd Downloads/
chmod 400 "Day 5.pem"
ssh -i "Day 5.pem" ubuntu@ec2-16-112-160-5.ap-south-2.compute.amazonaws.com
```

---

## 🟢 Phase 1 — Environment Verification (No Fixes)

```bash
docker --version
sudo systemctl status docker
ls
docker images
docker ps -a
```

Purpose:

* Confirm Docker daemon status
* Inspect existing images and containers
* Avoid assumptions

---

## 🟢 Phase 2 — Intentional State Reset

### Stop and Remove Existing Runtime State

```bash
docker ps -a
docker kill day5
docker rm d83
docker rmi day5
```

Purpose:

* Force rebuild from disk
* Eliminate residual runtime assumptions

---

## 🟢 Phase 3 — Rebuild Deployment from Disk

### Navigate to Repo

```bash
cd day5
ls
```

### Build Image from Scratch

```bash
docker build -t test .
```

### Run Container in Detached Mode

```bash
docker run -d --name test test
```

---

## 🟢 Phase 4 — Verification Using Logs

```bash
docker logs test
docker ps -a
```

Purpose:

* Confirm process is alive
* Confirm container is running
* Validate behavior via logs

---

## 🔥 Phase 5 — Intentional Failure Injection

### Kill the Running Container

```bash
docker kill test
docker ps -a
```

Observation:

* Exit code `137` (SIGKILL)

---

## 🟢 Phase 6 — Manual Recovery (No Rebuild)

```bash
docker start test
```

---

## 🔥 Phase 7 — Host-Level Failure

### Restart Docker Daemon

```bash
sudo systemctl restart docker
docker ps -a
```

Observation:

* Container exited
* Definition preserved

---

## 🟢 Phase 8 — Final Recovery

```bash
docker start test
docker stop test
docker ps -a
docker start test
```

Purpose:

* Prove repeated recovery
* Validate understanding of container lifecycle

---

## ✅ Final Pass Criteria (Met)

* Deployment rebuilt from memory
* Runtime failures handled without panic
* Logs used instead of guessing
* No dependency on CI or dashboards

---

## 🏁 Final Outcome

**Day 5 — COMPLETE**

You can now confidently state:

> “I can deploy a Dockerized app to a cloud VM, recover it from crashes, Docker restarts, and rebuild runtime state from disk without guidance.”

---

### Forward Reference

This test format should be reused whenever:

* Learning a new deployment tool
* Preparing for interviews
* Validating real-world readiness
