# Day 4 — Step 02: Understanding Drift
**Date:** February 8, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** Why drift exists, why Terraform allows it, and why it’s dangerous  

---

## 🎯 Goal of This Step

Understand **drift** at a system level:

- What drift actually is (not symptoms)
- Why Terraform does **not** prevent drift
- Why drift is inevitable in real environments
- Why drift turns safe plans into dangerous ones

No fixing yet.  
No commands yet.  
This step is **pure diagnosis**.

---

## 🧠 What Drift Really Means

**Drift** is the condition where:

> Terraform’s state no longer accurately represents real-world infrastructure.

This happens when:
- Terraform believes a resource exists in a certain shape
- Reality has changed **outside Terraform’s control**

Drift is **not** a Terraform bug.  
Drift is a **human + system interaction problem**.

---

## 🧱 How Drift Happens (Root Causes)

Drift occurs when **anything modifies infrastructure without updating Terraform state**.

Common causes:
- Manual changes in cloud console
- CLI actions (`aws s3 rm`, `kubectl apply`, etc.)
- Automated scripts not using Terraform
- Provider-side defaults changing over time
- Partial failures during apply
- Deleted resources outside Terraform

Terraform does **not block** these actions by design.

---

## ❗ Why Terraform Does NOT Prevent Drift

Terraform is intentionally **non-authoritative** over cloud platforms.

Reasons:
- Terraform cannot intercept all cloud changes
- Multiple tools may legitimately manage infra
- Hard-locking infrastructure would break real workflows
- Cloud providers do not offer global mutation locks

Terraform chooses **detectability**, not enforcement.

---

## 🔄 Relationship Between Drift, State, and Refresh

- **State** = Terraform’s memory of what it manages
- **Refresh** = Terraform checking reality against that memory
- **Drift** = Mismatch between memory and reality

Important:
- Refresh can *detect* drift
- Refresh cannot *fix* drift
- Fixing drift requires **apply** (or intentional state edits later)

---

## ⚠️ Why Drift Is Dangerous

Drift causes **unpredictable plans**.

Examples:
- Terraform may try to recreate critical resources
- Terraform may attempt destructive “corrections”
- Plans may include unexpected deletes
- Applies may fail halfway, worsening state accuracy

Most Terraform disasters start with **unnoticed drift**.

---

## 🧠 Core Mental Model (Lock This In)

Configuration = intent
State = ownership
Reality = truth


Drift exists when **ownership ≠ truth**.

Terraform always acts based on **state**, not reality directly.

---

## 🚫 What We Are NOT Doing Yet

- No fixing drift
- No state editing
- No import
- No taint
- No force-replace

Those come **after** understanding the danger.

---

## ✅ End Condition for Step 02

This step is complete only if you can explain:

- Why drift is inevitable
- Why Terraform allows drift
- Why drift makes plans dangerous
- Why refresh alone is not enough

Only then do we move to **corruption and recovery**.
