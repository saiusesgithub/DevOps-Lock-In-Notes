# Day 3 — Hour 4 — Environment Variables & Debugging

## Command Log + Key Learnings from Failures

---

## Goal of Hour 4

* Control container behavior using **environment variables**
* Change runtime behavior **without changing code logic**
* Understand the boundary between:

  * Image build-time
  * Container runtime
  * Docker Compose YAML validation

---

## 1. Modifying Service B to Use ENV

### Updated `server.sh`

```sh
#!/bin/sh

echo "service b started on port 5000"
echo "Listening on port : $SERVICE_B_PORT"

while true
do
  echo "service b alive on port $SERVICE_B_PORT"
  sleep 5
done
```

```bash
chmod +x server.sh
```

---

## 2. Why Logs Didn’t Change Initially (Important Debug Insight)

* `server.sh` was modified on the **host**
* Docker image had already been built earlier
* `COPY server.sh .` happens at **build time**, not runtime
* Since the image was reused, the container kept running **old code**

### Fix

```bash
sudo docker-compose up --build
```

This forced:

* Rebuild of the image
* Re-copy of updated `server.sh`
* New behavior visible in logs

---

## 3. Inline Environment Variables (Working Case)

### docker-compose.yml (service-b section)

```yaml
service-b:
  build: ./service-b
  container_name: service-b
  environment:
    SERVICE_B_PORT: 5000
```

### Observed Output

```text
service b alive on port 5000
```

---

## 4. Breaking the System — Removing ENV Variable

### What was done

* Removed only `SERVICE_B_PORT` line
* Left `environment:` key empty

### Resulting Error

```text
services.service-b.environment must be a mapping
```

### Key Learning

* `environment:` **cannot be empty**
* If the last env variable is removed, the **entire block must be removed**

### Correct Removal

```yaml
service-b:
  build: ./service-b
  container_name: service-b
```

---

## 5. Runtime Misconfiguration (ENV Missing)

After removing the entire `environment` block:

### Observed Output

```text
service b alive on port 
```

### Meaning

* Container started successfully
* `$SERVICE_B_PORT` existed but was **empty**
* This is a **runtime configuration issue**, not a Compose error

---

## 6. Using `.env` File (Recommended Pattern)

### `.env` file

```env
SERVICE_B_PORT=7000
```

### Initial Mistake

```yaml
env_file:
  - .env
```

Placed **outside** the service block → invalid structure

### Error Seen

```text
services.env_file must be a mapping
```

---

## 7. Correct `env_file` Placement

### Fixed docker-compose.yml

```yaml
services:
  service-a:
    build: ./service-a
    container_name: service-a

  service-b:
    build: ./service-b
    container_name: service-b
    env_file:
      - .env
```

---

## 8. Final Verified Behavior

```bash
sudo docker-compose up --build
```

### Observed Output

```text
service b alive on port 7000
```

---

## 9. Key Concepts Locked In

* ENV variables control **behavior**, not images
* Code changes require **image rebuilds**
* ENV changes do **not** require rebuilds
* Docker Compose validates YAML **before runtime**
* YAML indentation defines ownership
* Empty `environment:` blocks are invalid
* `env_file` must live **inside a service**

---

## Hour 4 Status

* ENV injection verified (inline + `.env`)
* Runtime vs config errors clearly distinguished
* Multiple real-world Compose errors debugged successfully
* Behavior changed without touching application logic

✅ **Hour 4 complete**
