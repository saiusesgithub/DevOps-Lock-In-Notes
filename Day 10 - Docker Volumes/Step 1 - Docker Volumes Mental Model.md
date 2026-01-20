# Day 10 — Docker Volumes Mental Model — **State & Persistence**

**Date:** Jan 16

**Theme:** Docker Volumes + Realism (State and Persistence)

**Goal of Step 1:** Build a **mechanical, predictable** mental model for where data lives and what survives when containers die, restart, rebuild, or are deleted.

---

## 0) Why this step exists (the real problem)

Docker is easy to use incorrectly because it *looks* like a VM but behaves like a **replaceable runtime**.

Most confusion comes from mixing these concepts:

* **Runtime** (container) vs **Template** (image) vs **Data** (state)

If you don’t separate those three in your head, you will:

* lose data accidentally
* rebuild systems and wonder why data “magically” stayed or vanished
* misunderstand what `docker rm`, `docker build`, and `docker compose down` truly do

This step is about **truth**, not features.

---

## 1) The 3 core objects (must be separated)

### A) Image (immutable template)

* Think: **blueprint**
* Built once, reused many times
* Doesn’t change at runtime
* Contains: OS layers, app code, dependencies
* Image rebuild means: “make a new blueprint version”

### B) Container (ephemeral runtime instance)

* Think: **running process + writable layer**
* Created from an image
* Has its own isolated filesystem view
* Can be stopped, started, killed, deleted
* **A container is expected to be disposable**

### C) Data / State (what your app produces)

* Think: **things created/modified after start**
* Examples:

  * database files
  * uploaded images
  * user-generated content
  * logs (sometimes)
  * caches (sometimes)
  * runtime configs, sessions (depends)

**Key reality:**
If state is stored only inside the container’s writable layer, then:

* container deleted ⇒ state lost

---

## 2) The default: where data lives without volumes

### Without volumes/bind mounts

* All writes happen inside the container’s **writable layer** (the container’s private filesystem changes)
* This writable layer is tied to the **container lifecycle**

✅ Your locked truth:

> If I don’t use volumes/bind mounts, my data lives **inside the container**.

Implication:

* **Restarting** a container: data remains (same container still exists)
* **Deleting** a container (`rm`): data disappears
* **Recreating** a container: starts fresh

---

## 3) The solution: mount external storage into the container

### What “mounting” means (simple)

Mounting means:

> “When the container reads/writes at a path, redirect those reads/writes to storage that lives outside the container’s disposable layer.”

So if you mount something at `/data`:

* writes to `/data` are not stored in the container’s writable layer
* they are stored in the external storage you mounted

This is the entire basis of persistence.

---

## 4) Two storage types we care about today

## 4.1 Named Volumes (Docker-managed storage)

### What it is

A **named volume** is:

* storage managed by Docker
* identified by a name (ex: `mydata`)
* stored somewhere on the host (Docker decides the exact path)

### Why it exists

It separates **volume lifecycle** from **container lifecycle**.

### How it feels conceptually

* You can delete and recreate containers freely
* As long as you attach the same volume name again, you get the same data back

### Ownership model

* Docker owns the storage location
* You manage it via Docker commands (list, inspect, remove)

---

## 4.2 Bind Mounts (Host-managed storage)

### What it is

A **bind mount** is:

* a direct mapping of a real host path to a container path
* ex: `./logs` on your machine ↔ `/app/logs` inside container

### Why it exists

It gives you:

* full control over the storage path
* natural editing from the host (great for dev workflows)

### How it feels conceptually

* Container sees your host folder as if it’s inside the container
* Changes sync both directions (host ↔ container)

### Ownership model

* You own the folder
* Docker just “wires it into the container”

✅ Your locked truth:

> Named volume is **Docker-managed**; bind mount is **user/host-managed** (you choose the folder).

---

## 5) The 4 lifecycle laws (these must become reflex)

These laws are the entire basis of Day 10.

### Law A — Deleting a container ≠ deleting a volume

* Containers can be disposable without losing data
* The volume is a separate resource

### Law B — Rebuilding an image ≠ changing a volume

* Image is blueprint code
* Volume is stored data
* They are independent

### Law C — Removing a volume = permanent data loss (unless backed up)

* The volume **is** the persistent storage
* Delete it and the stored data is gone

### Law D — Bind mount persistence comes from the host

* The host folder exists independent of Docker
* Docker cannot “accidentally delete your folder” by default; it’s your filesystem

---

## 6) “What survives what?” — mental table (NO COMMANDS)

This table is the core of the state model.

### Scenario: Data stored **inside container writable layer** (no mounts)

* Container **restart**: ✅ survives (same container)
* Container **stop/start**: ✅ survives
* Container **delete**: ❌ gone
* New container from same image: ❌ not present

### Scenario: Data stored in a **named volume** mounted into container

* Container **restart**: ✅ survives
* Container **delete**: ✅ survives (volume still exists)
* New container using same volume name: ✅ survives
* Image rebuild: ✅ survives
* Volume removed: ❌ gone

### Scenario: Data stored in a **bind mount** (host folder)

* Container restart/delete/recreate: ✅ survives
* Image rebuild: ✅ survives
* Host folder deleted: ❌ gone

---

## 7) The key distinction: lifecycle boundaries

### Container lifecycle (runtime)

* Start/Stop/Kill/Restart
* Remove container
* Recreate container

### Volume lifecycle (storage)

* Create volume
* Attach/detach volume
* Remove volume

The central operator mindset:

> Containers are cattle. Volumes are the barn where the cattle keep the milk.

(Meaning: replace containers freely; protect and manage state separately.)

---

## 8) “Truly wipe everything” mental model

✅ Your locked truth:

> To truly wipe persistent Docker data, you must delete the **volume** (or delete the **host folder** in case of bind mounts).

**Important nuance to remember later:**

* Removing a container does not remove named volumes
* Removing a compose stack does not necessarily remove volumes
* Persistent state must be explicitly destroyed if you want a clean slate

---

## 9) What this step deliberately avoided

To stay strict with Day 10 rules, Step 1 did **not**:

* run any commands
* use Docker Desktop
* talk about Kubernetes
* rely on “it should work” logic

This step only established the **predictive model**.

---

## 10) Step 1 Checkpoint (what I proved mentally)

By the end of Step 1, I can confidently say:

* I know the difference between **image**, **container**, and **data**
* I understand that containers are **ephemeral** by design
* I know that persistence requires **mounts**
* I can explain the difference between:

  * named volumes (Docker-managed)
  * bind mounts (host-managed)
* I know what I must delete to truly wipe state:

  * delete the volume / delete the host folder

---

## 11) Terms to remember (revision list)

* **Ephemeral**: expected to be replaced without fear
* **State**: data produced/modified during runtime
* **Mount**: mapping external storage into container path
* **Writable layer**: container-only filesystem changes
* **Named volume**: Docker-managed persistent storage
* **Bind mount**: host path mapped into container
* **Lifecycle boundary**: what resource survives which operation

---

## 12) Why this matters operationally (real-world)

If you run:

* databases (Postgres, MySQL)
* queues (RabbitMQ)
* uploads folder for a web app
* configuration that must persist

Then you must answer confidently:

* Where is the data stored?
* What happens if the container dies?
* What happens if I redeploy?
* What must I delete to reset the environment?

Day 10 is training exactly that operator reflex.
