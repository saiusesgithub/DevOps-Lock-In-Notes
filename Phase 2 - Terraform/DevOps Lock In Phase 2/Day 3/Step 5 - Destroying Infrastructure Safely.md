# Step-05 - Destroying-Infrastructure-Safely

**Date:** February 8, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Step Theme:** Proving ownership by destroying real infrastructure predictably

---

## 🎯 Step Objective

Destroy the S3 bucket using Terraform **safely and intentionally**, and prove:

* Destroy is just another plan + apply cycle
* Terraform deletes only what it owns (as defined by state)
* State is updated after destruction
* Nothing is deleted “randomly” when state is correct

Destroy is not optional. It is the ownership test.

---

## 🧠 Pre-Step Context

Right now:

* The S3 bucket exists in AWS
* The bucket is present in `terraform.tfstate`
* Terraform owns the bucket lifecycle

We will destroy **using Terraform only**.

---

## 🔒 Destroy Safety Model (Must Be Understood)

Terraform destroy is safe because:

* It uses state to know what it manages
* It generates a plan (prediction) before execution
* It deletes exactly the resources in that plan

Danger comes from:

* Wrong/missing state
* Manual edits to state
* Running destroy in the wrong directory/environment

---

## 🧪 Prediction Discipline (Mandatory)

Before running anything, you must predict:

* What will `terraform plan` show if we run `terraform plan -destroy`?
* What will `terraform destroy` show?
* Will Terraform ask for confirmation?
* What will happen to `terraform.tfstate` after destruction?

No commands until predictions are written.

---

## ✅ Safe Execution Procedure

You will run, in order:

1. `terraform plan -destroy`

   * Read the plan carefully
   * Confirm that only the expected S3 bucket is marked for deletion

2. `terraform destroy`

   * Confirm prompt
   * Observe resource deletion

3. Verify local state and directory

   * Re-check `terraform.tfstate`
   * Ensure resources list returns to empty

---

## 🚫 Hard Boundaries

* Do NOT delete the bucket from AWS console
* Do NOT delete or edit `terraform.tfstate` manually
* Do NOT run destroy from any other directory

Terraform must remain the single source of truth.

---

## ❓ Reasoning Questions (After Destroy)

After the destroy completes, you must be able to answer:

* Why did Terraform know what to delete?
* What would happen if state was missing?
* What exactly changed in state after destroy?
* Why destroy is not inherently dangerous?

---

## 🔒 Locked Mental Models

* Destroy is reconciliation in reverse
* State defines deletion boundaries
* “Fear of destroy” = “lack of state confidence”

---
