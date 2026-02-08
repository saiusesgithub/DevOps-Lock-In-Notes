# Step-04 - Terraform-Plan

**Date:** February 8, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Step Theme:** Understanding `terraform plan` as reasoning, not execution

---

## 🎯 Step Objective

Understand **what `terraform plan` actually does** and why it is safe.

This step exists to:

* Remove fear around Terraform commands
* Separate reasoning from execution
* Make Terraform behavior predictable before anything changes

No infrastructure will be created.
No state will be modified.
No cloud APIs will be called.

---

## 1️⃣ What `terraform plan` Is (Conceptually)

`terraform plan` is Terraform’s **reasoning phase**.

It answers one question:

> “If I were to apply this configuration right now, what would change?”

It does **not**:

* Create resources
* Modify resources
* Destroy resources

It only **computes a diff** between:

* Desired state (configuration)
* Current state (state + provider)

---

## 2️⃣ What `terraform plan` Reads

When you run `terraform plan`, Terraform reads:

1. **Terraform configuration (`.tf` files)**

   * To understand the desired state

2. **State (if it exists)**

   * To understand what Terraform currently manages

3. **Provider schemas (if any)**

   * To understand resource structure

In our current setup:

* Configuration exists
* State does NOT exist
* Providers do NOT exist

This is still a valid scenario.

---

## 3️⃣ What `terraform plan` Does in Our Case

Given this configuration:

```hcl
terraform {}
```

Terraform reasons:

* Desired state: “No resources should exist”
* Current state: “No resources are managed”
* Difference: None

So the expected plan is:

> **No changes. Infrastructure is up-to-date.**

This is a **successful plan**, not a failure.

---

## 4️⃣ What `terraform plan` Does NOT Do

`terraform plan` does NOT:

* Create a state file
* Create `.terraform/` directory
* Download providers
* Touch cloud APIs
* Modify configuration

It is a **read-only operation**.

---

## 5️⃣ Why `terraform plan` Is Safe

`terraform plan` is safe because:

* It does not execute changes
* It does not persist state
* It does not alter infrastructure

This is why Terraform encourages:

> **Plan before apply**

Planning exposes intent before execution.

---

## 6️⃣ Why a “No Changes” Plan Is Important

A plan showing:

> “No changes. Infrastructure is up-to-date.”

Means:

* Desired state matches current state
* Terraform’s mental model is consistent
* Nothing is missing or unexpected

“No changes” is a **valid and correct outcome**.

---

## 7️⃣ Correct Mental Model to Lock In

> `terraform plan` is Terraform thinking, not doing.

If plan surprises you:

* Your configuration is unclear
* Your state is wrong
* Or drift exists

Plan is the safest place to discover problems.

---

## 🔎 Day 2 – Step 04: terraform plan — Questions & Refined Answers

### 1) Why does `terraform plan` not change anything?
Because `terraform plan` only computes the difference between desired state (configuration) and current state. It does not execute any actions.

---

### 2) Why can `terraform plan` run without state?
If no state exists, Terraform assumes it manages nothing and compares the desired state against an empty current state. Planning is still possible.

---

### 3) Why is “No changes” a success?
“No changes” means the desired state exactly matches the current state. Terraform has nothing to create, update, or destroy.

---

### 4) Why is `terraform plan` required before `apply`?
`terraform apply` internally performs a planning step. Running `terraform plan` separately is not strictly required, but it is strongly recommended so changes can be reviewed before execution.
