# 📅 Day 5 — Variables, tfvars & Outputs (Making Terraform Flexible)
**Date:** February 10, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** Separating intent, values, and visibility  
**Environment:** Existing Terraform project (local state, AWS provider already configured)

---

## 🎯 Primary Goal for Day 5

Remove **hard-coding** from Terraform and understand how Terraform handles:

- Inputs (variables)
- Runtime values (tfvars)
- Exposed information (outputs)

By the end of Day 5, Terraform configs should feel:
- Reusable
- Environment-aware
- Less fragile

If infrastructure behavior still requires editing core `.tf` files → Day 5 has failed.

---

## 🧠 Why Day 5 Exists (Context)

So far:
- Day 1–4 focused on **how Terraform thinks**
- Day 5 focuses on **how Terraform adapts**

Real infrastructure is never:
- Single environment
- Single value
- Single use-case

Variables and outputs are what turn Terraform from a demo tool into a **real system**.

---

## 🧱 Core Focus Areas for Today

### 1️⃣ Variables (Inputs)
- Why variables exist
- How Terraform resolves variable values
- Default vs required variables
- Variable typing and validation (conceptual first)

Goal:
> Change behavior **without touching core resource definitions**.

---

### 2️⃣ `terraform.tfvars` (Runtime Configuration)
- Why tfvars exist
- How Terraform loads variable values
- Why tfvars ≠ config
- How tfvars enable environment separation

Goal:
> Same Terraform code, different behavior per environment.

---

### 3️⃣ Outputs (Visibility)
- Why outputs exist
- What Terraform exposes vs hides
- How outputs are computed
- Why outputs depend on state

Goal:
> Terraform becomes observable, not opaque.

---

## 🧪 Execution Style for Day 5 (Very Important)

Today follows the same strict loop:

1. Predict behavior before writing anything
2. Introduce **one concept at a time**
3. Run `terraform plan` before `apply`
4. Inspect state + output
5. Reflect on what changed and why

No jumping ahead to “best practices”.

---

## 🧱 Planned Steps for Day 5

### Step 01 — Why Hardcoding Is a Smell
- Identify hardcoded values in existing config
- Reason about why this breaks reuse

---

### Step 02 — Variables (Conceptual → Hands-On)
- Define variables
- Use them in resources
- Observe how plan changes when values change

---

### Step 03 — tfvars & Value Resolution Order
- Introduce `terraform.tfvars`
- Change behavior without touching `.tf`
- Learn precedence rules

---

### Step 04 — Outputs & Terraform Visibility
- Define outputs
- Observe outputs after apply
- Understand outputs as state-derived values

---

### Step 05 — Controlled Mistakes
- Missing variable values
- Wrong types
- Unexpected plan behavior
- Debug variable resolution logically

---

## 🚫 Hard Boundaries for Day 5

- No modules
- No remote state
- No workspaces
- No environment automation
- No copy-paste examples

This day is about **mechanics**, not patterns.

---

## ✅ End Condition for Day 5

Day 5 is complete only if I can:

- Modify infra behavior without editing core `.tf` files
- Explain where Terraform gets variable values from
- Predict variable resolution order
- Use outputs to expose useful information
- Debug variable-related plan failures calmly

Only then does Day 6 (dependencies & graph thinking) make sense.

---
