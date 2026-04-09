# ⚔️ DevOps Lock-In Phase 5 — Day 1 - Step 1

### 09/04/2026

## Observability (EC2 Setup + Node Exporter)

---

# 🧠 Phase Goal

Transition from:
→ "I can deploy systems"

To:
→ "I can SEE and DEBUG systems in real-time"

---

# ☁️ Step 1 — Observability Lab Setup (EC2)

## 🎯 Objective

Create a **safe testing environment** to experiment with monitoring tools without affecting production.

---

## ⚙️ EC2 Configuration

* AMI: Ubuntu (latest LTS)
* Instance Type: t2.micro / t3.micro
* Key Pair: Created for SSH access

---

## 🔐 Security Group Configuration

Opened ports: (Inbound Rules)

| Port | Purpose            |
| ---- | ------------------ |
| 22   | SSH access         |
| 3000 | Grafana (later)    |
| 9090 | Prometheus (later) |
| 9100 | Node Exporter      |
| 8080 | Test app (nginx)   |

👉 Important Insight:
Docker exposing a port ≠ publicly accessible
AWS Security Group must allow traffic

---

## 🔑 SSH Access

ssh -i key.pem ubuntu@<public-ip>

---

# 🐳 Step 2 — Docker Setup

## 🎯 Objective

Enable container-based deployment for all observability tools

---

## ⚙️ Installed Docker

Validated using:

* docker --version
* docker run hello-world

---

## 🔧 Permission Fix (Didn't Do)

Added user to docker group to avoid sudo:

* sudo usermod -aG docker ubuntu
* newgrp docker

---

## ✅ Validation Test (nginx)

* docker run -d -p 8080:80 nginx

Access:

http://<ec2-ip>:8080

---

## 🧠 Key Learning

* Docker port mapping exposes container internally
* AWS Security Group controls external access
* Both must align for public access

---

# 📊 Step 3 — Node Exporter (First Observability Component)

## 🎯 Objective

Expose **system-level metrics** from EC2

---

## 🧠 What is Node Exporter?

Node Exporter is a **metrics collector** that:

* Runs on a machine
* Exposes system data via HTTP

### Metrics include:

* CPU usage
* Memory usage
* Disk usage
* Network stats

---

## ⚙️ Deployment (Docker)

Used official image:

prom/node-exporter

Mapped:

9100 → 9100

---

## 🌐 Access Metrics

http://<ec2-ip>:9100/metrics

---

## 📄 Output Format

Example:

node_cpu_seconds_total{cpu="0",mode="user"} 19.31
node_memory_MemAvailable_bytes 12345678

---

# 🧠 Understanding Metrics Format

Each line contains:

* Metric name → node_cpu_seconds_total
* Labels → {cpu="0", mode="user"}
* Value → 19.31

👉 This represents **time-series data**

---

# ❓ Why HTTP?

* Prometheus uses **pull model**
* HTTP allows:

  * Easy access
  * Debugging via browser / curl
  * Standard communication

---

# ❓ Why Plain Text?

* Lightweight
* Faster to parse
* Optimized for frequent scraping

---

# ❓ Why NOT JSON?

* JSON is heavier
* Nested structure = slower parsing
* Prometheus needs speed at scale

---

# 🔁 Data Flow (Current Stage)

```
[ Node Exporter ]
↓ (HTTP /metrics)
(raw metrics available)
```

👉 No storage yet
👉 No visualization yet

---

# 🧠 Key Observations

* Node Exporter does NOT store data
* It only exposes current system state
* Prometheus will later scrape and store this

---

# 🔥 DevOps Insight

At this stage:

* We are not monitoring yet
* We are only **making the system observable**

---

# ⚡ Problems Faced & Fixes

## ❌ Issue: nginx not accessible

Cause:

* Port 8080 not open in security group

Fix:

* Added inbound rule for port 8080

---

## 🧠 Lesson

Infrastructure debugging requires checking layers:

1. Application (container running?)
2. Port binding (docker mapping?)
3. Firewall (security group?)
4. Network (correct IP?)

---

# 🎯 End State (So Far)

* EC2 instance running
* Docker installed and configured
* Node Exporter running
* Metrics accessible via HTTP endpoint

---

# 🚀 Next Step

Bring in:

👉 **Prometheus (metrics collector + storage)**

This will:

* Pull metrics from Node Exporter
* Store time-series data
* Enable querying

---

# 🧠 Lock-In Reflection

Node Exporter taught:

* How systems expose internal state
* Why observability starts with data exposure
* Importance of lightweight, scrape-friendly formats
