# ⚔️ DevOps Lock-In Phase 5 — Prometheus - Step 2

### 09/04/2026

---

# 🧠 Purpose of Prometheus

Prometheus is a **monitoring + alerting system** designed to:

* Collect metrics from systems
* Store them as time-series data
* Allow querying and analysis

👉 It answers:

* Is my system healthy?
* What is happening over time?
* Where is performance degrading?

---

# 🧩 Core Role in Observability

Observability pipeline (current stage):
```
[ Node Exporter ] → exposes metrics
↓
[ Prometheus ] → collects + stores + queries
```
👉 Prometheus is the **brain of the system**

---

# ⚡ Key Concepts (VERY IMPORTANT)

## 1. Target

A target is any system Prometheus monitors

Example:

* 172.31.12.50:9100

👉 This is where metrics are exposed

---

## 2. Scraping

Prometheus periodically pulls metrics from targets

Example:

* Every 15 seconds → fetch metrics

👉 Prometheus is **pull-based**, not push-based

---

## 3. Scrape Interval

Defines how often data is collected

Example:

* 15s → every 15 seconds

---

## 4. Scrape Config

Defines:

* What to monitor
* Where to find it

---

# ⚙️ Configuration File

File used:

prometheus.yml

---

## 🧾 Structure

### Global Section

Defines global settings

Example:

scrape_interval: 15s

---

### scrape_configs Section

Defines monitoring targets

---

## ✅ Working Configuration

```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "Node Exporter"
    static_configs:
      - targets: ["172.31.12.50:9100"]
```

---

# 🧠 Deep Understanding of Config

## job_name

* Logical name of the target group
* Used in queries and labels

---

## static_configs

* Static list of targets
* Used when targets are fixed

---

## targets

* Actual endpoints
* Format: IP:PORT

---

# ⚠️ Important Learning — Container Networking

## ❌ Problem Faced

Tried using:

localhost:9100

---

## ❌ Why it failed

* Prometheus runs inside a container
* Node Exporter runs separately
* "localhost" refers to the container itself

---

## ✅ Solution

Used EC2 private IP:

172.31.12.50:9100

👉 This allows container → host communication

---

# 🐳 Running Prometheus (Docker)

## Requirements

* Port exposure
* Config file access

---

## Command Used

* Port mapping: 9090:9090
* Volume mount for config

---

## 🔑 Volume Mount (VERY IMPORTANT)

```
-v ~/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
```

### What it does:

* Links host file → container
* Prometheus reads config from host

---

## 🧠 Why this matters

Without volume mount:

* Container uses default config
* Cannot customize targets

---

# 🌐 Prometheus UI

Access:
```
http://<ec2-ip>:9090
```
---

## 🔍 Important Sections

### 1. Status → Targets

Shows health of monitored systems

* UP → working
* DOWN → issue

---

### 2. Graph Tab

Used to query metrics

---

# 📊 Querying Metrics

Example:

node_cpu_seconds_total

---

## 🧠 What Query Returns

Each result includes:

* Metric name
* Labels
* Value

---

## Example Output
```
node_cpu_seconds_total{cpu="0",mode="user"} 24.05
```
---

# 🧠 Understanding Labels (VERY IMPORTANT)

Labels provide dimensions to metrics

Example:

* cpu → which core
* mode → user/system/idle

---

## 🔥 Why Labels Matter

They allow:

* Filtering
* Aggregation
* Detailed analysis

---

# 🧠 Time-Series Data

Prometheus stores:

metric + labels + timestamp → value

👉 This allows tracking changes over time

---

# ⚡ Debugging Learnings

If target shows DOWN:

Check:

1. Node Exporter running?
2. Correct IP/port?
3. Network accessibility?
4. Security group rules?

---

# 🎯 Final System State

* Prometheus container running
* Node Exporter target = UP
* Metrics successfully scraped
* Queries returning live data

---

# 🧠 DevOps Insights

## 1. Monitoring is pull-based

Prometheus actively fetches data

---

## 2. Configuration defines behavior

Wrong config = no monitoring

---

## 3. Networking is critical

Containers + host communication must be understood

---

## 4. Observability starts with data collection

Without Prometheus:

* Metrics are useless

---

# 🚀 What You Achieved

* Built first monitoring pipeline
* Understood scraping mechanism
* Queried real system metrics
* Learned container networking impact

---

# 🔜 Next Step

👉 Grafana (Visualization Layer)

* Convert metrics → dashboards
* Make system human-readable

---

# 🧠 Lock-In Reflection

Prometheus taught:

* How monitoring systems operate internally
* Importance of structured configuration
* Real-world debugging of distributed systems
* Fundamentals of time-series observability
