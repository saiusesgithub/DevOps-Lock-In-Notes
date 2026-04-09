# ⚔️ DevOps Lock-In Phase 5 — Grafana - Step 3

### 09/04/2026

---

# 🧠 Role of Grafana

Grafana is a **visualization layer** for observability systems.

It does NOT:

* collect metrics ❌
* store metrics ❌

It DOES:

* query data sources (Prometheus)
* render dashboards (graphs, panels)
* make system behavior human-readable

👉 Think:
"Prometheus knows. Grafana shows."

---

# 🧩 Position in Stack
```
[ Node Exporter ] → exposes metrics
↓
[ Prometheus ] → collects + stores
↓
[ Grafana ] → visualizes (UI layer)
```
---

# ⚡ Key Concepts

## 1. Data Source

A backend Grafana queries.

In this project:

* Prometheus = data source

👉 Grafana sends queries → Prometheus returns data

---

## 2. Dashboard

A collection of panels (visual components)

Used to monitor system health:

* CPU
* Memory
* Disk
* Network

---

## 3. Panel

Single visualization unit

Types:

* Time series (line graph)
* Gauge
* Stat
* Table

---

## 4. Query (PromQL)

Grafana uses **PromQL** to fetch data

Example:

node_cpu_seconds_total

👉 Same queries you tested in Prometheus UI

---

# 🐳 Deployment (Docker)

## Command Used

```
docker run -d -p 3000:3000 --name grafana grafana/grafana
```

---

## Access UI

http://<ec2-ip>:3000

---

## Default Login

* Username: admin
* Password: admin

👉 Password change required on first login

---

# ⚙️ Connecting Grafana → Prometheus

## Steps Performed

1. Open Grafana
2. Go to Settings → Data Sources
3. Add new data source
4. Select Prometheus

---

## 🔑 Critical Config

URL used:

[http://172.31.12.50:9090](http://172.31.12.50:9090)

---

## ❌ Why NOT localhost?

* Grafana runs in container
* localhost refers to Grafana container
* Prometheus runs separately

👉 So connection fails

---

## ✅ Why Private IP Works

* Refers to EC2 host network
* Both containers can reach it

---

## Validation

Click: Save & Test

Expected:
✔ Data source is working

---

# 📊 Dashboard Setup

## Import Method (Used)

Grafana provides pre-built dashboards

Dashboard ID used:

1860

---

## Steps

1. Dashboards → New → Import
2. Enter ID (1860)
3. Select Prometheus data source
4. Click Import

---

## Result

Full system dashboard showing:

* CPU usage
* Memory usage
* Disk usage
* Network usage

👉 All in real-time

---

# 🧠 What Happens Internally

1. Dashboard loads
2. Grafana sends PromQL queries
3. Prometheus returns time-series data
4. Grafana renders graphs

---

# ⚡ Understanding CPU Visualization

Metric used:

node_cpu_seconds_total

---

## Important Insight

CPU Idle ≠ CPU Usage

👉 Actual usage:

100 - idle

---

# ⚡ Interacting with Dashboard

## Actions Performed

* Changed time range (5m, 1h)
* Hovered over graphs
* Observed per-core usage

---

# ⚠️ Common Issues

## ❌ Dashboard empty

Causes:

* Prometheus not connected
* Wrong data source
* No metrics available

---

## ❌ Cannot connect to Prometheus

Check:

* Correct IP/port
* Prometheus running
* Network reachability

---

# 🎯 System State After Grafana

* Node Exporter → working
* Prometheus → collecting
* Grafana → visualizing

👉 Full observability pipeline achieved

---

# 🔥 DevOps Insights

## 1. Visualization completes observability

Raw data is useless without interpretation

---

## 2. Separation of concerns

* Exporter → data
* Prometheus → storage
* Grafana → visualization

---

## 3. Faster debugging

Instead of guessing:
→ observe patterns
→ identify spikes

---

# 🚀 What You Achieved

* Built real monitoring dashboard
* Connected distributed components
* Visualized system metrics in real-time

---

# 🔜 Next Step

👉 Alerts (Detection + Response Layer)

---

# 🧠 Lock-In Reflection

Grafana taught:

* How to convert data → insights
* Importance of dashboards in production
* Role of visualization in debugging
