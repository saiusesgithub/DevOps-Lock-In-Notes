# ⚔️ DevOps Lock-In Phase 5 — Alerts & Notifications (Detailed Notes)

### 09/04/2026

---

# 🧠 Purpose of Alerts

Alerts are the **reaction layer** of observability.

They answer:

* When something goes wrong → who gets notified?
* How fast can we respond?

---

# ❗ Problem Without Alerts

* Dashboards require manual checking
* Issues can happen anytime (e.g., 3 AM)
* No visibility → no reaction

---

# ✅ Solution

Alerts automate detection + notification

👉 "If condition is met → trigger action"

---

# 🧩 Alerting Architecture

Basic flow:

```
[ Node Exporter ] → metrics
↓
[ Prometheus ] → stores data
↓
[ Alert Rule ] → evaluates condition
↓
[ Contact Point ] → sends notification

```
---

# ⚡ Key Components

## 1. Alert Rule

Defines:

* What to monitor
* When to trigger

---

### Example Rule

Condition:

```
CPU usage > 70%
```

---

## 2. Query (PromQL)

Used to compute system state

Example:

```
1 - avg(rate(node_cpu_seconds_total{mode="idle"}[1m]))
```

---

## 🧠 Why This Query?

* Idle time = unused CPU
* 1 - idle = actual usage

👉 Gives accurate total CPU usage across cores

---

## ❌ Why NOT use only "user"?

```
rate(node_cpu_seconds_total{mode="user"}[1m])
```

Problems:

* Ignores system CPU
* Ignores other modes
* Not total CPU usage

---

# ⚡ Alert Condition

Configured as:

```
WHEN last() OF query(A) IS ABOVE 0.7
```

---

## 🧠 Meaning

* Take latest value
* Check if > 70%

---

# ⚡ Evaluation Behavior

## Evaluate Every

* How often alert is checked

Example:

```
10 seconds
```

---

## Pending Period

* Condition must hold for a duration

Example:

```
30 seconds
```

---

## 🧠 Why Pending Period?

Prevents:

* False alerts
* Temporary spikes

---

# ⚡ Alert States

## 1. Normal

Condition not met

---

## 2. Pending

Condition met, but waiting duration

---

## 3. Firing 🔥

Condition confirmed → alert triggered

---

# ⚡ Contact Points

Defines:

* Where alert is sent

Examples:

* Discord
* Email
* Slack
* Webhook

---

# ⚔️ Discord Integration

## Steps

1. Create Discord webhook
2. Add in Grafana as Webhook contact point
3. Attach to alert rule

---

## Result

When alert fires:

👉 Notification appears in Discord

---

# ⚡ Triggering Alert (Testing)

Used:

```
yes > /dev/null &
yes > /dev/null &
```

---

## 🧠 Why multiple commands?

* System has multiple CPU cores
* One process ≠ full system load

---

# ⚡ Stopping Load

```
pkill yes
```

---

# 🎯 Final System State

* Metrics collected
* Data stored
* Dashboard visualized
* Alerts firing
* Notifications received

---

# 🔥 DevOps Insights

## 1. Observability is layered

* Data → Prometheus
* Visualization → Grafana
* Reaction → Alerts

---

## 2. Alerts must be meaningful

Bad alert:

* Too sensitive
* Too frequent

Good alert:

* Actionable
* Reliable

---

## 3. Avoid alert fatigue

Too many alerts → ignored alerts

---

## 4. Monitoring ≠ Alerting

Monitoring shows data
Alerting triggers action

---

# 🚀 What You Achieved

* Built full monitoring pipeline
* Implemented real alert system
* Integrated notification system
* Simulated real-world incident

---

# 🧠 Interview Insight

If asked:

"How do alerts work in your system?"

Answer:

* Metrics collected via Node Exporter
* Prometheus stores and evaluates data
* Grafana defines alert rules
* When condition matches → notification sent via webhook

---

# 🔜 Next Level (Future)

* Alertmanager (advanced routing)
* Slack integration
* PagerDuty
* Severity-based alerts

---

# 🧠 Lock-In Reflection

Alerts taught:

* How systems react automatically
* Importance of thresholds
* Real-world incident detection flow
