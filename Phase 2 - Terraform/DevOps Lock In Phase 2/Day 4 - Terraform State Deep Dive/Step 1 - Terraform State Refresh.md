# 📅 Day 4 — Step 01: What State Refresh Actually Does

**Date:** February 8, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** Understanding how Terraform reconciles state with reality

**Environment:** Existing Terraform project (no new infrastructure)

---

## 🎯 Objective of This Step

Build a precise, non-hand-wavy understanding of **what “refresh” means in Terraform** — without running commands blindly.

By the end of this step, you should be able to explain:

* What Terraform checks during refresh
* What refresh can change
* What refresh will *never* change
* Why refresh alone does not fix drift

This step is about **mental models**, not commands.

---

## 🧠 The Core Idea

Terraform maintains **two parallel truths**:

1. **State file** — Terraform’s memory of what it manages
2. **Real-world infrastructure** — what actually exists in the cloud

A **refresh** is the act of:

> Asking providers: “Is what I remember still true?”

Nothing more. Nothing less.

---

## 🔄 What “Refresh” Actually Does

Conceptually, during refresh Terraform:

1. Reads the **current state file**
2. For each managed resource:

   * Calls the **provider**
   * Asks the cloud: “What is the current value of this resource?”
3. Compares:

   * State values ↔ real-world values
4. Updates the **state file** *if differences are found*

Important:

* Refresh **does not use the configuration file to make changes**
* Refresh **does not modify infrastructure**

It is a **read-only reconciliation step**.

---

## 🧱 What Refresh Can Change

Refresh may update **only the state file**, such as:

* Actual IDs
* ARNs
* Attributes that changed outside Terraform
* Provider-returned metadata

Example:

* Someone enables versioning on an S3 bucket manually
* Refresh updates the `versioning` field in state

Infrastructure stays untouched.

---

## 🚫 What Refresh Will NEVER Do

Refresh will **never**:

* Create new resources
* Modify existing resources
* Delete resources
* Rewrite `.tf` configuration files
* “Fix” drift automatically

Refresh is **observational**, not corrective.

---

## 🧨 Why Refresh Alone Does NOT Fix Drift

Drift means:

> Real-world infrastructure ≠ Desired configuration

Refresh only updates **state**, not configuration.

After refresh:

* State matches reality
* Configuration may still differ

Result:

* `terraform plan` will still propose changes

Terraform fixes drift **only through apply**, never through refresh.

---

## 🔍 When Refresh Happens Automatically

Terraform performs refresh implicitly during:

* `terraform plan`
* `terraform apply`
* `terraform destroy`

Unless explicitly disabled, refresh is part of Terraform’s normal lifecycle.

This is why plans usually reflect current reality.

---

## 🧠 Mental Model to Lock In

> Refresh is Terraform asking:
> “Is my memory still correct?”

It is **not** Terraform saying:

* “Let me fix things”
* “Let me sync config”

Those require **plan + apply**.

---

## ✅ End Condition for Step 01

This step is complete only if you can confidently explain:

* Why refresh is safe
* Why refresh is insufficient on its own
* Why Terraform trusts refreshed state more than configuration

Once locked in, we move to:

👉 **Step 02 — Understanding Drift (Why It Exists at All)**
