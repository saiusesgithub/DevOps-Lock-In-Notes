# Day 3 — Hour 3 (Docker Compose Introduction)

## Command Log (Including Compose Installation)

---

### Install Docker Compose (Standalone Binary)

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

```bash
docker-compose version
```

---
### Why Docker Compose had to be installed separately

The docker.io package from Ubuntu repositories installs Docker Engine only
It does not include the docker compose CLI plugin
Therefore, Docker Compose was installed as a standalone binary

On this EC2 instance, the valid command is:

```docker-compose``` (hyphen)

NOT ```docker compose```

This is common on servers and older/minimal Linux images.

---

### docker-compose.yml Creation

```bash
nano docker-compose.yml
```

```yaml
services:
  service-a:
    build: ./service-a
    container_name: service-a

  service-b:
    build: ./service-b
    container_name: service-b
```

---

### Start System (Foreground)

```bash
docker-compose up
```

Stopped using `Ctrl + C`.

---

### Start System (Detached)

```bash
docker-compose up -d
```

```bash
docker-compose ps
```

---

### Service Name DNS Verification

```bash
docker exec service-a ping service-b
```

```bash
docker exec service-a ping localhost
```

---
### Expected behavior after Docker Compose

```docker exec service-a ping service-b```

Ping succeeds
service-b resolves via Docker’s internal DNS
Confirms both containers are attached to the same Compose-created network


```docker exec service-a ping localhost```

Ping succeeds, but only to service-a itself
Confirms localhost still refers to the container, not other services

#### Difference from Hour 2

Hour 2: Containers were isolated → DNS resolution failed

Hour 3: Docker Compose automatically created a shared bridge network

Result: Containers can communicate using service names

---

### Shutdown

```bash
docker-compose down
```

```bash
docker ps
```

---

### Hour 3 Status

* Multi-container system started with single command
* Automatic Docker network created
* Service-name DNS resolution working
* Container isolation resolved via Compose networking
