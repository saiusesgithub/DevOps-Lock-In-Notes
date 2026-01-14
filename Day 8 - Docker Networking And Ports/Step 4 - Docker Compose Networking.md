# 🧱 Day 8 — Step 4: Docker Compose Networking (Detailed Notes)

> **Purpose of Step 4**
>
> To prove — slowly and mechanically — that **Docker Compose networking is not a new system**, but simply an **automation of container ↔ container networking (Step 3)**.
>
> This step intentionally reused the same server logic and gradually introduced Compose features to avoid cognitive overload.

---

## 🎯 Core Outcome of Step 4

By the end of Step 4, the following were proven through execution and observation:

* Docker Compose **automatically creates a network**
* All services are attached to that network by default
* **Service names become DNS hostnames**
* Containers communicate using `service-name:container-port`
* `ports:` only affects **host ↔ container** traffic
* Internal container traffic **never uses published ports**
* Docker Compose is **convenience, not magic**

---

## 🧠 Mental Model Before Using Compose

Everything learned earlier still applies:

* Containers run in isolated network namespaces
* Docker provides DNS **per network**
* `localhost` is always local to the current container
* `0.0.0.0` is required for accepting external traffic

Docker Compose does **not change networking rules**.
It only **reduces the number of commands you type**.

---

## 1️⃣ Clean Slate & Slow Mode Setup

A fresh directory was created to reduce mental load and avoid interference from Step 3 artifacts.

```bash
mkdir day8-compose
cd day8-compose
```

This ensured:

* No leftover containers
* No leftover networks
* Full clarity of what Compose creates

---

## 2️⃣ Create the Server Application (No Compose Yet)

### server.py

```bash
nano server.py
```

```python
from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Hello from inside the container")

server = HTTPServer(("0.0.0.0", 3000), Handler)
print("Server listening on port 3000")
server.serve_forever()
```

Key decisions:

* `serve_forever()` creates a long-running service
* `0.0.0.0` allows traffic from outside the container namespace

Verified with:

```bash
cat server.py
```

---

## 3️⃣ Create Dockerfile (Still No Compose)

```bash
nano Dockerfile
```

```dockerfile
FROM python:3.10-slim

WORKDIR /app
COPY server.py .

EXPOSE 3000

CMD ["python", "server.py"]
```

Important clarifications:

* `EXPOSE` is documentation only
* No ports are published here

---

## 4️⃣ Manual Build & Run (Confidence Step)

Before Compose was introduced, the container was tested manually.

### Build image

```bash
docker build -t day8-compose-server .
```

### Run container (with port mapping)

```bash
docker run --name test-server -p 8080:3000 day8-compose-server
```

Observed:

```
Server listening on port 3000
```

Test from host:

```bash
curl localhost:8080
```

Output:

```
Hello from inside the container
```

Cleanup:

```bash
docker rm test-server
```

This step removed anxiety before introducing Compose.

---

## 5️⃣ Minimal Docker Compose Introduction

### docker-compose.yml (minimal)

```yaml
version: "3.9"

services:
  server:
    build: .
```

Started with:

```bash
docker compose up
```

Observed:

```
server | Server listening on port 3000
```

Compose automatically:

* Built the image
* Created a container
* Created a **default network**
* Attached the service to that network

---

## 6️⃣ Observing the Auto-Created Network

Without defining any network explicitly:

```bash
docker network ls
```

A network similar to this appeared:

```
day8-compose_default
```

Inspection:

```bash
docker network inspect day8-compose_default
```

Observed:

* `server` container listed
* Internal IP address (172.x.x.x)

This confirmed:

> Docker Compose performs the same networking steps you manually did in Step 3.

---

## 7️⃣ Adding Ports (Host Access Only)

### Updated docker-compose.yml

```yaml
version: "3.9"

services:
  server:
    build: .
    ports:
      - "8080:3000"
```

Restarted Compose:

```bash
docker compose up
```

Tested from host:

```bash
curl localhost:8080
```

Output:

```
Hello from inside the container
```

Key observation:

* Internal networking unchanged
* Only host ↔ container access was added

---

## 8️⃣ Adding a Client Service (Internal DNS Proof)

### Final docker-compose.yml

```yaml
version: "3.9"

services:
  server:
    build: .
    ports:
      - "8080:3000"

  client:
    image: curlimages/curl
    depends_on:
      - server
    command: ["sh", "-c", "sleep 2 && curl http://server:3000"]
```

Started with:

```bash
docker compose up
```

Observed output:

```
client | Hello from inside the container
client exited with code 0
server exited with code 137
```

---

## 9️⃣ Understanding the Exit Codes (Important Clarity)

### Client exit code: `0`

* Successful execution
* curl completed
* Job finished correctly

### Server exit code: `137`

* Server was force-stopped by Docker Compose
* Signal: SIGKILL
* Reason: Compose shuts down all services after client exits

This is expected behavior for learning setups and **not an error**.

---

## 🔒 Final Mental Locks (Step 4)

1. Docker Compose always creates a network by default
2. All services are attached to that network
3. Service names are DNS hostnames
4. Containers communicate via `service-name:container-port`
5. `ports:` only affects host access
6. Internal container traffic never uses published ports
7. Docker Compose is automation, not abstraction

---

✅ **Day 8 — Step 4 COMPLETE**

Docker Compose networking is now mechanical, predictable, and boring — which is exactly the goal.
