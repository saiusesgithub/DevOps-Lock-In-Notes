# Day 3 — Hour 1 (Service A)

## Command Log

---

### System Setup (New EC2)

```bash
sudo apt update
sudo apt install docker.io -y
docker --version
sudo systemctl status docker
```

### Docker Permissions

```bash
docker ps
sudo usermod -aG docker $USER
newgrp docker
docker ps
```

---

### Project Workspace

```bash
mkdir -p ~/day3-compose/app
cd ~/day3-compose/app
pwd
```

---

### Application Script

```bash
nano app.sh
```

```bash
#!/bin/sh

echo "Service A started"
while true
do
  echo "Service A running..."
  sleep 5
done
```

```bash
chmod +x app.sh
ls -l
```

---

### Dockerfile

```bash
nano Dockerfile
```

```Dockerfile
FROM alpine:latest
WORKDIR /app
COPY app.sh .
CMD ["./app.sh"]
```

---

### Build & Run (No Compose)

```bash
docker build -t service-a .
docker run --rm service-a
```

Stopped using `Ctrl+C`.

---

### Hour 1 Status

* Service A image built successfully
* Container ran continuously
* Logs printed at 5s intervals
