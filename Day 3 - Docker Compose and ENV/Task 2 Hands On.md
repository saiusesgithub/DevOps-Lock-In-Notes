# Day 3 — Hour 2 (Service B + Container Isolation)

## Command Log (No Explanations)

---

### Service B Setup

```bash
cd ~/day3
mkdir service-b
cd service-b
ls
```

---

### Service B Script

```bash
nano server.sh
```

```bash
#!/bin/sh

echo "service b started on port 5000"

while true
do
  echo "service b alive"
  sleep 5
done
```

```bash
chmod +x server.sh
ls -l
cat server.sh
```

---

### Dockerfile — Service B

```bash
nano Dockerfile
```

```Dockerfile
FROM alpine:latest
WORKDIR /service
COPY server.sh .
CMD ["./server.sh"]
```

```bash
cat Dockerfile
```

---

### Build Images

```bash
cd ~/day3/service-b
docker build -t service_b .

cd ~/day3/service-a
docker build -t service_a .
```

---

### Run Containers (Manual, No Compose)

#### Terminal 1 — Service B

```bash
sudo docker run --name service_b service_b
```

#### Terminal 2 — Service A

```bash
sudo docker run --name service_a service_a
```

---

### Container Isolation Checks

```bash
sudo docker exec service_a ping service_b
```

```bash
sudo docker exec service_a ping localhost
```

---

### Observations Logged

* Both Service A and Service B ran simultaneously
* `ping service_b` failed with bad address / DNS error
* `ping localhost` succeeded inside Service A
* Containers confirmed isolated with no shared networking

---

### Hour 2 Status

* Manual multi-container system running
* Isolation behavior observed
* Proven need for explicit networking / Compose
