# Day 4 — Step 04: State Recovery Strategies (Safe vs Unsafe)
**Date:** February 9, 2026  
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** How to recover when state is wrong — without destroying infrastructure  

---

## 🎯 Goal of This Step

Learn **how Terraform state can be recovered safely**, and more importantly:

- What recovery actions are **safe**
- What actions are **dangerous**
- When Terraform must be stopped immediately

This step is about **decision-making**, not commands.

---

## 🧠 First Principle (Non-Negotiable)

> **Never “fix” state unless you fully understand the failure mode.**

State recovery is not trial-and-error.  
One wrong move can permanently destroy real infrastructure.

---

## 🟢 SAFE State Recovery Strategies

These strategies **preserve Terraform’s ownership model**.

### 1️⃣ Refreshing State (Safe)

Use case:
- Drift exists
- State structure is intact

What it does:
- Updates state to match reality
- Does NOT change infrastructure

Safe because:
- Terraform still knows what it owns
- No ownership is invented or lost

---

### 2️⃣ Re-running `terraform init` (Safe)

Use case:
- Provider versions changed
- Backend config changed
- `.terraform/` directory missing

What it does:
- Reinitializes environment
- Re-establishes provider plugins
- Reconnects to backend (if any)

Safe because:
- Does not touch state data
- Does not touch infrastructure

---

### 3️⃣ Importing Existing Resources (`terraform import`) (Safe)

Use case:
- Resource exists in cloud
- Terraform does not yet track it

What it does:
- Adds resource to state
- Establishes ownership **without creating or deleting**

Safe because:
- Ownership is explicitly declared
- No guessing by Terraform

This is the **correct way** to recover missing ownership.

---

### 4️⃣ Using State Backups (Safe)

Use case:
- State file accidentally modified or overwritten

What it does:
- Restores previous known-good state

Safe because:
- Restores Terraform’s memory
- No assumptions about reality

This is why **state backups are critical**.

---

## 🔴 UNSAFE State Recovery Strategies

These cause **Terraform to lose or invent ownership**.

### ❌ 1️⃣ Deleting `terraform.tfstate`

Why people do it:
- “Let Terraform recreate everything”

Why it’s dangerous:
- Terraform forgets all ownership
- May recreate resources that already exist
- May cause naming conflicts
- May destroy data

This is **state amnesia**.

---

### ❌ 2️⃣ Manually Editing State Without Full Understanding

Why people do it:
- “I’ll just fix this one field”

Why it’s dangerous:
- One incorrect ID = wrong resource
- Can cause Terraform to delete the wrong thing
- Can silently corrupt ownership

State is **not configuration**.  
It is **live memory**.

---

### ❌ 3️⃣ Sharing One State File Across Environments

Why people do it:
- Laziness
- Misunderstanding environments

Why it’s dangerous:
- Dev actions affect prod
- Terraform cannot distinguish ownership boundaries

This causes **cross-environment destruction**.

---

### ❌ 4️⃣ Forcing Apply on a Broken Plan

Why people do it:
- Panic
- “Let’s just try”

Why it’s dangerous:
- Terraform executes exactly what the plan says
- If plan is wrong, damage is guaranteed

Terraform is obedient, not intelligent.

---

## 🧠 Decision Framework (Very Important)

Before **any recovery action**, ask:

1. Does Terraform still know what it owns?
2. Is state structure intact?
3. Is reality known or uncertain?
4. Is the plan explainable line-by-line?

If **any answer is unclear → STOP**.

---

## 🧱 Core Mental Model

Drift recovery = safe apply

State recovery = surgical

State guessing = disaster


Terraform is safe only when **ownership is correct**.

---

## 🚫 What We Are Still NOT Doing

- No backend migration
- No remote state locking
- No partial imports
- No force-replace
- No taint

Those require this foundation first.

---

## ✅ End Condition for Step 04

This step is complete only if you can confidently explain:

- Which recovery methods are safe
- Which are dangerous
- Why deleting state is almost never correct
- Why import exists
- When Terraform must be stopped completely

Only after this do we conclude Day 4.
