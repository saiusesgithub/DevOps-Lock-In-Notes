# Day 5 — Hour 3

## Manual Deployment to a Cloud VM (Hands-on)

> This hour marks the transition from **building artifacts** to **running long‑lived systems**. Everything here was done manually on a real Ubuntu VM to expose real deployment behavior.

---

## 1. Goal of Hour 3

* Deploy a Dockerized app on a **cloud VM**
* Run it in **detached mode**
* Observe **real runtime behavior** (not CI, not local)
* Understand why containers exit or stay alive

This hour answers:

> “What does it actually mean for an app to *run* on a server?”

---

## 2. Getting the App Onto the VM

### Step 2.1 — Verify Git Availability

```bash
git --version
```

Confirmed Git was available on the VM.

---

### Step 2.2 — Clone the Repository

```bash
git clone https://github.com/saiusesgithub/day5.git
```

Result:

* Repository cloned into `day5/`

---

### Step 2.3 — Navigate into the Repo

```bash
ls
cd day5
ls
```

Files present:

* `Dockerfile`
* `app.sh`

---

### Step 2.4 — Inspect Repository State

```bash
ls -al
```

Confirmed:

* Clean repo
* No build artifacts
* No hidden runtime state

---

## 3. Inspecting the Artifact (Before Running)

### Step 3.1 — Inspect Dockerfile

```bash
cat Dockerfile
```

Observed:

* Base image: `ubuntu:latest`
* Script copied to `/app.sh`
* CMD executes `/app.sh`

This confirms:

* The container lifecycle depends entirely on `app.sh`

---

### Step 3.2 — Inspect app.sh

```bash
cat app.sh
```

Initial contents:

```bash
#!/bin/bash
echo "App is running inside a Docker container"
```

Observation:

* Script prints once and exits
* No long‑running process

---

## 4. Building the Image on the VM

### Step 4.1 — Build Docker Image

```bash
docker build -t day5 .
```

Results:

* Image built successfully
* Image tagged as `day5:latest`
* Build happened **on the VM**, not in CI

Key point:

> This image is now a **deployment artifact** on a long‑lived machine.

---

## 5. Running the Container (First Attempt)

### Step 5.1 — Run Container in Detached Mode

```bash
docker run -d --name day5 day5
```

Container ID returned, indicating startup.

---

### Step 5.2 — Inspect Container State

```bash
docker ps -a
```

Observed:

* Container **exited immediately**
* Exit code: `0`
* Status: `Exited (0)`

Important:

> `-d` does NOT keep a container alive.

---

## 6. Reading Runtime Logs (Mandatory)

### Step 6.1 — View Container Logs

```bash
docker logs day5
```

Output:

```
App is running inside a Docker container
```

Conclusion:

* App ran successfully
* Process ended
* Docker behaved correctly

---

## 7. Converting App into a Long‑Lived Service

### Step 7.1 — Modify app.sh

Goal:

* Keep the main process alive
* Make container long‑running

Updated `app.sh`:

```bash
#!/bin/bash
echo "App is running inside a Docker container"

while true
do
    echo "sleeping for 500"
    sleep 500
done
```

Key idea:

> Containers live as long as their **main process lives**.

---

### Step 7.2 — Rebuild the Image

```bash
docker build -t day5 .
```

---

### Step 7.3 — Remove Old Container

```bash
docker rm day5
```

---

### Step 7.4 — Run Updated Container

```bash
docker run -d --name day5 day5
```

---

### Step 7.5 — Verify Runtime State

```bash
docker ps
```

Observed:

* Container status: `Up`
* App is now **long‑lived**

---

## 8. SSH Disconnect Survival Test

### Step 8.1 — Exit SSH

```bash
exit
```

Waited ~15–20 seconds.

---

### Step 8.2 — Reconnect and Verify

```bash
docker ps
```

Observed:

* Container still running

This proves:

* App is **not tied to SSH**
* Deployment survives human disconnect

---

## 9. Key Lessons from Hour 3

* A container is just a Linux process
* `docker run -d` ≠ keep alive
* Exit code `0` can still mean **service stopped**
* Logs must be checked before conclusions
* Long‑running services require blocking or looping processes
* Real deployment begins when SSH becomes irrelevant

---

### Status

* Manual deployment: ✅ completed
* Long‑lived container: ✅ confirmed
* SSH survival: ✅ confirmed
* Ready for next phase: **Logs, failure & recovery**
