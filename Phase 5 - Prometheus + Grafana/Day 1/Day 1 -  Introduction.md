# ⚔️ DevOps Lock-In Phase 5 — Day 1

### 09/04/2026

## Observability (Prometheus + Grafana)

---

# 🧠 What is Observability?

Observability = Ability to understand what is happening inside a system **without guessing**

It answers:
- Is my system healthy?
- What is failing?
- Where is the bottleneck?
- What happened when something broke?

---

# 🧩 Core Pillars (just awareness)

- Metrics → numbers over time (CPU, memory)
- Logs → text events (errors, requests)
- Traces → request flow (ignore for now)

👉 In this phase: **FOCUS = Metrics**

---

# ⚡ Tool Roles (VERY IMPORTANT)

## 🔵 Prometheus → Brain (collector + database)

- Pulls metrics from systems
- Stores time-series data
- Has its own query language (PromQL)

👉 Think:
"Prometheus asks servers → give me your data"

---

## 🟣 Grafana → Eyes (visualization)

- Connects to Prometheus
- Turns data into dashboards
- Helps humans understand metrics

👉 Think:
"Grafana shows what Prometheus knows"

---

## 🟢 Node Exporter → Sensor (data source)

- Runs on machine
- Exposes system metrics:
  - CPU
  - Memory
  - Disk
  - Network

👉 Think:
"Node Exporter = machine talking about itself"

---

# 🔄 How Everything Connects
```
[ Node Exporter ]  → gives metrics
        ↑
        │ (HTTP endpoint)
        ↓
[ Prometheus ] → collects + stores
        ↓
[ Grafana ] → visualizes
```
---

# ⚙️ Key Concepts (ONLY THESE)

## 1. Target
A system Prometheus monitors

Example:
- localhost:9100 (Node Exporter)

---

## 2. Scraping
Prometheus pulling data at intervals

Example:
- every 15 seconds → get metrics

---

## 3. Scrape Config
Where you tell Prometheus:
- WHO to monitor
- WHERE they are

---

## 4. Metrics Format
Data looks like:

cpu_usage 0.65  
memory_usage 0.80  

👉 time-series numbers

---

# 🧠 Important Mental Models

## ❗ Prometheus is PULL-based
- It does NOT wait for data
- It actively fetches data

---

## ❗ If target is DOWN
- Prometheus shows:
  → "DOWN"

👉 This is your first debugging signal

---

## ❗ Grafana does NOT store data
- Only reads from Prometheus

---

# ⚡ What You ACTUALLY Need to Learn Today

## DO:
- Run Prometheus
- Run Node Exporter
- See targets = UP
- Query basic metrics
- Connect Grafana

---

## DON'T:
- Learn full PromQL
- Learn advanced configs
- Learn alerts yet

---

# 🎯 End Goal (Day 1)

You should be able to answer:

- Where does Prometheus get data from?
- What is a scrape config?
- What happens if Node Exporter stops?
- How does Grafana get data?

---

# 🧠 DevOps Insight

Deployment tells you:
→ "App is running"

Observability tells you:
→ "System is healthy OR about to fail"

---

# 🚀 Next Step

👉 Start:
- Run Node Exporter
- Run Prometheus
- Make target = UP

---

# 🔥 Rule

If something doesn't work:
→ Don't skip  
→ Debug  
→ Understand WHY