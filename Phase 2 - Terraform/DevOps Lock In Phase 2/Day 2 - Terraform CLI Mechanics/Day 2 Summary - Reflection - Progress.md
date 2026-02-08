# Phase-2-Terraform/Day-02_Reflection_Summary.md

**Date:** February 8, 2026 (supposed to do this on 9th Feb but sunday on 8th feb and finished Day 1 pretty quickly)

**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Day Theme:** Terraform CLI mechanics, state creation, and predictability

---

## 🎯 Day 2 Goal (Revisited)

The goal of Day 2 was **not** to provision infrastructure.

The goal was to:
- Fully understand how Terraform CLI behaves locally
- Remove false assumptions about `init`, `plan`, `apply`, and state
- Make Terraform’s behavior boring, explainable, and predictable

---

## 🧱 Step-by-Step Breakdown

### 🔹 Step 01 — Terraform Working Directory

**What I did:**
- Understood that a Terraform project is simply a directory with `.tf` files
- Learned that Terraform does not care about file names or folder structure
- Confirmed that Terraform is strictly scoped to the current directory

**Learning:**
- Terraform only loads `.tf` files in the current directory
- Directory-level isolation is a deliberate design choice to prevent cross-environment damage

---

### 🔹 Step 02 — `terraform init` (Initialization)

**What I did:**
- Ran `terraform init` in a completely empty directory
- Observed that init succeeded but created **no files**
- Re-ran init after adding minimal config

**Initial assumptions / mistakes:**
- Assumed `terraform init` always creates:
  - `.terraform/`
  - `.terraform.lock.hcl`
  - state files

**Correction / learning:**
- `terraform init` is **configuration-driven**
- Init only prepares what the configuration demands
- No providers → no `.terraform/`
- No providers → no lock file
- Init prepares *capability*, not data

---

### 🔹 Step 03 — Smallest Possible Terraform Configuration

**What I did:**
- Created a single file (`main.tf`) containing only:
  - `terraform {}`
- Used this to make Terraform recognize a valid desired state

**Initial assumptions / mistakes:**
- Thought state would be created as soon as a config exists
- Thought init would automatically create Terraform artifacts once config exists

**Correction / learning:**
- A valid configuration does not automatically create state
- Terraform waits until it must record ownership (during apply)
- Desired state can explicitly mean “manage nothing”

---

### 🔹 Step 04 — `terraform plan` (Pure Reasoning)

**What I did:**
- Ran `terraform plan` with an empty desired state
- Observed a successful “No changes” output

**Initial assumptions / mistakes:**
- Slight confusion on how plan works without state
- Initially unsure whether plan required state to exist

**Correction / learning:**
- `terraform plan` can run without state
- If state doesn’t exist, Terraform assumes an empty current state
- “No changes” is a **successful and correct** plan outcome
- Plan is read-only and never writes state

---

### 🔹 Step 05 — `terraform apply` (Execution + State Creation)

**What I did:**
- Ran `terraform apply` after a no-change plan
- Observed that apply:
  - Did nothing to infrastructure
  - Still created `terraform.tfstate`

**Initial assumptions / mistakes:**
- Assumed state would not be created if no resources exist

**Correction / learning:**
- `terraform apply` **always writes state**
- State records ownership and reconciliation, not just resources
- Terraform must remember that “zero resources” is intentional
- Empty state is a valid, stable, managed state

---

## 🧠 Key Mental Models Locked In

- Terraform CLI behavior is entirely **configuration-driven**
- `init` prepares systems; it does not invent files
- `plan` is reasoning only
- `apply` is execution **plus state recording**
- State represents ownership and reconciliation, not just infrastructure
- Terraform refuses to assume intent — everything must be declared

---

## 🔁 Rebuild-from-Memory Status

I can now:
- Start from an empty directory
- Predict exactly what each Terraform command will do
- Explain why files appear or do not appear
- Explain why state exists even with zero resources

---

## ⚠️ What Is Intentionally Not Covered Yet

- Providers
- Real infrastructure
- Remote state
- Cloud APIs

These are deferred to Day 3 onward by design.

---

## ✅ Day 2 Completion Verdict

Day 2 is **successfully completed**.

Terraform CLI commands now feel:
- Predictable
- Explainable
- Boring (in the best way)

This makes moving to real infrastructure safe and controlled in Day 3.
