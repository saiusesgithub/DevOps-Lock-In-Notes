# Day 3 — Hour 5 — `depends_on` vs Readiness

## Controlled Failure & Core DevOps Lesson

---

> `depends_on` guarantees **only the order of container start**, not that the dependency is ready, initialized, or usable.

It does **not** wait for:

* files to exist
* ports to open
* services to finish setup
* applications inside the container to be ready

---

## Goal of Hour 5

* Understand the **difference between container start and service readiness**
* Prove that `depends_on` is **not a readiness mechanism**
* Observe a real failure caused by assuming otherwise

---

## Setup Overview (Simplified Dependency Model)

### Service B (Dependency)

* Starts container
* Sleeps for 10 seconds (simulated slow initialization)
* Creates a readiness signal: `/ready`
* Continues running

### Service A (Dependent)

* Starts immediately
* Checks for `/ready`
* Logs whether dependency is ready or not
* Exits

No networking involved. No DNS tricks.
Pure dependency timing.

---

## Service B Script

```sh
#!/bin/sh

echo "Service B starting..."
echo "Initializing (sleeping 10s)..."
sleep 10

echo "READY" > /ready
echo "Service B is READY"

while true
do
  sleep 5
done
```

---

## Service A Script

```sh
#!/bin/sh

echo "Service A started"

if [ -f /ready ]; then
  echo "Service A: dependency READY"
else
  echo "Service A: dependency NOT READY"
fi

sleep 20
```

---

## docker-compose.yml Used

```yaml
services:
  service-b:
    build: ./service-b
    container_name: service-b

  service-a:
    build: ./service-a
    container_name: service-a
    depends_on:
      - service-b
```

---

## Observed Output (Key Lines)

```text
service-b  | Service B starting...
service-a  | Service A started
service-a  | Service A: dependency NOT READY
service-b  | Service B is READY
```

---

## Timeline Breakdown

1. Docker Compose starts **service-b container**
2. Docker Compose starts **service-a container** (order respected)
3. Service A runs immediately
4. `/ready` file does not exist yet
5. Service A logs dependency NOT READY and exits
6. Service B finishes initialization later

Order respected. Readiness not guaranteed.

---

## Core Lessons Locked In

* `depends_on` controls **container start order only**
* Containers ≠ applications
* Application readiness happens **inside** the container
* Docker Compose does not wait for application-level readiness

---

## Why This Matters in Real Systems

This exact issue occurs when:

* Web app starts before database initialization
* API starts before cache/message broker is ready
* Worker starts before dependent service setup completes

Assuming `depends_on` solves this leads to:

* race conditions
* startup failures
* flaky systems

---

## Correct Mental Model

* Docker starts processes
* Processes may need time to become usable
* Readiness must be:

  * explicitly checked
  * retried
  * or handled via health checks / wait logic

---

## Hour 5 Status

* Dependency vs readiness distinction proven
* `depends_on` behavior clearly understood
* False assumptions eliminated
* Operator-level understanding achieved

✅ **Hour 5 complete**
