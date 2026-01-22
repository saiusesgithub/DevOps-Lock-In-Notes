# 🔥 Day 3 — Docker Compose & Environment Variables

---

## 1. Why Docker Compose Exists

Docker alone is designed for **single-container execution**.

Real applications are **systems**, not containers.
A real system includes:

* Multiple services (app + dependency)
* Configuration
* Networking
* Startup order
* Persistent state

Without Docker Compose, running such a system requires:

* Multiple `docker build` and `docker run` commands
* Manual networking
* Manual environment configuration
* Manual cleanup

👉 **Docker Compose = declarative system definition**

> “This is my application system. Run it exactly like this.”

---

## 2. Dockerfile vs docker-compose.yml

### Dockerfile

* Describes **how to build ONE image**
* Build-time instructions
* Produces an **image**
* Uses: `FROM`, `RUN`, `COPY`, `CMD`, `ENTRYPOINT`

### docker-compose.yml

* Describes **how to run MULTIPLE containers together**
* Runtime orchestration
* Produces a **running system**
* Uses: `services`, `networks`, `volumes`, `environment`

❗ Confusing these layers leads to:

* unnecessary rebuilds
* broken configuration
* debugging the wrong layer

---

## 3. What Docker Compose Actually Does

When you run:

```bash
docker compose up
```

Compose performs these steps mechanically:

1. Reads `docker-compose.yml`
2. Creates a **default bridge network**
3. Builds images (if required)
4. Creates containers
5. Attaches containers to the same network
6. Starts containers in dependency order
7. Streams logs to terminal

No hidden logic. No magic.

---

## 4. Services ≠ Containers

In Docker Compose, you define **services**.

A **service** is:

* A runtime template
* A definition of how containers should be run

A service can:

* Run one container
* Later scale to multiple containers

You operate:

* **services**
  Not:
* individual containers

That’s why commands are:

```bash
docker compose up
docker compose ps
docker compose logs
```

---

## 5. Networking — The Most Important Concept

### The Common Beginner Mistake

Using `localhost` for container-to-container communication.

### Why This Fails

* Each container has its own **network namespace**
* `localhost` inside a container = **that container only**
* Not the host
* Not other containers

---

### How Containers Actually Communicate

Docker Compose automatically:

* Creates a shared network
* Adds internal DNS resolution

Each service gets:

* A hostname = **service name**

Example:

```yaml
services:
  app:
  db:
```

Inside `app`:

* `db` resolves via DNS
* `db:5432` works
* `localhost:5432` fails

✅ **Service name = DNS hostname**

---

## 6. Ports Are NOT Networking

Ports are used for:

* Host ↔ Container access
* Browser access
* Debugging

Ports are **not** used for:

* Container ↔ Container communication

Inside the Docker network:

* Containers communicate directly
* Port mappings are irrelevant

This means:

```yaml
ports:
  - "5432:5432"
```

Has **zero impact** on container-to-container traffic.

---

## 7. Environment Variables (ENV)

### Purpose

Environment variables control **runtime behavior**, not code.

Benefits:

* Same image
* Different behavior
* No rebuilds

This is **real operations**.

---

### Ways to Define Environment Variables

#### Inline list

```yaml
environment:
  - DB_HOST=db
  - DB_PORT=5432
```

#### Key-value mapping

```yaml
environment:
  DB_HOST: db
  DB_PORT: 5432
```

#### `.env` file

```env
DB_HOST=db
DB_PORT=5432
```

Docker Compose automatically loads `.env`.

---

### Why ENV Matters

If environment variables are:

* missing
* misnamed
* incorrect

Then:

* containers may start
* applications will fail
* logs reveal the root cause

---

## 8. depends_on — Exact Behavior

### What `depends_on` DOES

* Controls **startup order**
* Ensures dependency container starts first

### What `depends_on` DOES NOT

* Does not wait for readiness
* Does not check health
* Does not guarantee dependency is usable

Applications must:

* retry connections
* handle startup failures
* rely on logs for debugging

---

## 9. Volumes — Basic Understanding

Containers are **ephemeral**.

Volumes exist to:

* Persist data
* Share state
* Survive container restarts

Without volumes:

* Data disappears
* Databases reset
* Systems behave deceptively

Volumes = **state**
Containers = **processes**

---

## 10. Day 3 Mental Shift

Before Day 3:

* Running containers

After Day 3:

* Operating **systems**

Docker Compose is where:

* Tool usage ends
* Systems thinking begins

Mental load is expected.
Discomfort means learning is happening.

---

## 11. Core Truths to Remember

* Dockerfile builds images
* Compose runs systems
* Services talk via service names
* `localhost` is a trap
* Ports are for host access only
* ENV vars change behavior without rebuilds
* Logs tell the truth

---

