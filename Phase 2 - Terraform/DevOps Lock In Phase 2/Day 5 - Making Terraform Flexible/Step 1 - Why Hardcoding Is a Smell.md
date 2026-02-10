# Day 5 — Step 01: Why Hardcoding Is a Smell
**Date:** February 10, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** Separating intent from values  
**Environment:** Existing Terraform project (AWS provider configured)

---

## 🎯 Objective of This Step

Identify **why hardcoded values make Terraform fragile**, and lock in the rule:

> **Terraform configuration should describe structure and intent — not environment-specific values.**

If changing environments requires editing core `.tf` files, this step has failed.

---

## 🧠 What “Hardcoding” Means in Terraform

Hardcoding = embedding **environment-specific values directly inside resource blocks**, such as:

- Resource names
- Regions
- CIDR blocks
- Instance sizes
- Bucket names
- Tags that vary by environment

These values are not structural — they are **inputs**.

---

## 🔍 Why Hardcoding Is a Problem (Mechanically)

### 1️⃣ Breaks Reusability
- Same config cannot be reused for dev/stage/prod
- Copy-pasting folders becomes the “solution”
- Drift and inconsistency grow over time

Terraform stops being IaC and becomes **template sprawl**.

---

### 2️⃣ Increases Blast Radius
- One small change requires editing multiple files
- Mistakes in prod are easy because files look similar
- Review becomes harder because logic and values are mixed

---

### 3️⃣ Destroys Predictability
- Changing a value requires touching core logic
- Hard to know if a change is:
  - structural (safe)
  - behavioral (risky)

Terraform plans become harder to reason about.

---

### 4️⃣ Encourages Anti-Patterns
Hardcoding leads to:
- One repo per environment
- Manual diffs between folders
- Accidental prod changes
- “Just change it quickly” mindset

This defeats Terraform’s design.

---

## 🧱 What Should Be Hardcoded (Very Small List)

Hardcoding is acceptable **only** for:
- Resource relationships
- Structural wiring
- Terraform-only logic (counts, references, dependencies)

Example:
- One resource referencing another
- Dependency expressions
- Graph relationships

These are **not environment-specific**.

---

## 🧠 Correct Mental Model (Lock This In)

Hardcode structure
Parameterize behavior


- Structure = what exists
- Behavior = how it varies

Terraform variables exist **only** to support this separation.

---

## 🔮 Prediction (Before Next Step)

After introducing variables:
- Core `.tf` files will change **less often**
- Behavior will change without touching resource blocks
- Terraform plans will become easier to reason about

---

## 🚫 What We Are NOT Doing Yet

- No variables yet
- No tfvars yet
- No outputs yet

This step is **diagnostic**, not corrective.

---

## ✅ End Condition for Step 01

This step is complete only if I can:

- Identify which values should never be hardcoded
- Explain why hardcoding causes long-term risk
- Clearly separate structure vs behavior in Terraform configs

Next:
👉 **Step 02 — Variables: Declaring Inputs Properly**
