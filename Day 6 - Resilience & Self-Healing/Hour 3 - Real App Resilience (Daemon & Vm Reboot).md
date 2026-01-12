# 🔥 Day 6 — Hour 3

## Real Application Resilience: Docker Daemon & VM Reboot

> These notes document **real, irreversible proof** of how Docker restart policies behave with a **real application**, not a synthetic BusyBox test.
> This hour bridges the gap between *mechanics* (Hour 2) and *production judgment*.

---

## 1️⃣ Objective of Hour 3

The goal of Hour 3 was to answer **one critical question**:

> *What actually happens to a real application container when things go wrong at the system level?*

Specifically, we wanted to **prove**, not assume:

* What happens when the **app exits normally**
* What happens when **Docker daemon restarts**
* What happens when the **entire VM reboots**
* Whether Docker remembers **human intent** for real apps

---

## 2️⃣ The Real App Under Test (Day‑5 Artifact)

### Application Structure

```text
Dockerfile
app.sh
```

**Dockerfile**

```Dockerfile
FROM ubuntu:latest
COPY app.sh /app.sh
RUN chmod +x /app.sh
CMD ["/app.sh"]
```

**app.sh**

```bash
#!/bin/bash
echo "App is running inside a Docker container"
```

### Key Characteristics of This App

* Short‑lived process
* Prints a message
* Exits successfully (`exit 0` implicitly)
* Not a daemon
* Not intended to stay alive

This makes it **perfect** for exposing restart‑policy dangers.

---

## 3️⃣ Baseline: Running the Real App (No Restart Policy)

### Commands Executed

```bash
docker build -t day5 .

docker run -d --name day5 day5

docker ps -a
docker logs day5
```

### Observed Reality

* Container executed `/app.sh`
* Log printed once
* Container exited with:

  ```text
  Exited (0)
  ```
* Docker performed **no recovery**

### Meaning

> A successful exit is still a stop. Docker does nothing unless told otherwise.

This establishes the **real‑app control case**.

---

## 4️⃣ Applying `restart: always` to a Real App

### Command

```bash
docker rm day5

docker run -d --restart always --name day5 day5
```

### Immediate Observations

```bash
docker ps -a
docker inspect day5 --format '{{.RestartCount}}'
docker logs day5
```

### Observed Reality

* Container exited successfully (`exit 0`)
* Docker immediately restarted it
* Logs repeated continuously
* `RestartCount` increased rapidly
* Container entered an **infinite restart loop**

### Critical Insight

> **`restart: always` restarts even on SUCCESSFUL exits.**

Docker logic is:

```text
Container stopped
Restart policy = always
Human did not stop it
→ restart
```

Docker does not interpret success vs failure.

---

## 5️⃣ Why This Is Dangerous in Production

For short‑lived apps:

* Docker forces an infinite loop
* CPU and logs are wasted
* Monitoring may falsely show "healthy"
* Bugs and design mistakes are hidden

This proves:

> `restart: always` is ONLY safe for long‑running daemons.

---

## 6️⃣ Human Stop vs `restart: always`

### Command

```bash
docker stop day5
```

### Observed Reality

* Container stopped
* Restart loop halted

### Meaning

> Docker **respects human intent temporarily**.

But the story does **not** end here.

---

## 7️⃣ Docker Daemon Restart (Real App + `always`)

### Command

```bash
sudo systemctl restart docker
```

### Observed Reality

* Docker daemon restarted
* Container status changed to:

  ```text
  Restarting (0)
  ```
* Logs resumed printing
* Restart loop restarted

### Critical Proof

> `restart: always` **forgets human stop** after daemon restart.

Docker treats daemon restart as a system failure, not a human decision.

---

## 8️⃣ VM Reboot (Real App + `always`)

### Command

```bash
sudo reboot
```

### Observed Reality After Reboot

```bash
docker ps -a
docker inspect day5 --format '{{.RestartCount}}'
docker logs day5
```

Results:

* Container resurrected automatically
* Restart loop resumed
* `RestartCount` continued increasing

### Final Proof

> **`restart: always` resurrects containers after VM reboot, even if a human stopped them earlier.**

This behavior is deterministic and by design.

---

## 9️⃣ Core Mental Models Locked in Hour 3

* Docker reacts to **container stop events**, not app correctness
* A successful exit is still a stop
* `restart: always` enforces presence, not health
* Human intent is NOT persistent across daemon restarts or reboots (with `always`)
* Restart policies can **create failure loops**, not just heal them

---

## 🔟 When to Use (and NOT Use) `restart: always`

### Safe Use

* Web servers
* API services
* Long‑running daemons
* Processes where exit always means failure

### Dangerous Use

* One‑shot scripts
* Batch jobs
* Init tasks
* Cron‑like workloads

---

## 1️⃣1️⃣ Hour‑3 Final Realization

> Docker restart policies do not understand your application.
> They only understand **whether a container is running**.

Therefore:

* Reliability comes from **design + judgment**
* Automation must be paired with **correct intent**

Hour 3 is **fully complete**.
