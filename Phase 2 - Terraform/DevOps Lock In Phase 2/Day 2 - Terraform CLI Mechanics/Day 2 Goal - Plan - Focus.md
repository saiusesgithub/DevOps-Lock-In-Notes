# 📅 Day 2 — Terraform CLI Mechanics & Working Directory

**Date:** February 8, 2026 (supposed to do this on 9th Feb but sunday on 8th feb and finished Day 1 pretty quickly)

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** Making the Terraform CLI boring, predictable, and explainable

**Environment:** Local machine, empty directory, no cloud, no credentials

---

## 🎯 Primary Target for Day 2

Remove all mystery around **Terraform CLI commands**.

By the end of Day 2:

* Terraform commands feel **mechanical**, not magical
* I know exactly what each command:

  * Reads
  * Writes
  * Modifies
* Running `init`, `plan`, `apply`, and `destroy` is predictable

If the CLI still feels like a black box, Day 2 is a failure.

---

## 🧠 Focus for the Day

Day 2 focuses on **Terraform’s local behavior**, not cloud infrastructure.

Key focus areas:

* Terraform working directory
* Files Terraform expects and generates
* What `terraform init` actually does
* How `plan` differs from `apply`
* How `destroy` fits into the same loop
* How state starts existing locally

---

## 🧱 Execution Steps for Day 2 (High-Level)

### Step 1 — Terraform Working Directory

* What makes a directory a Terraform project
* What Terraform looks for before running
* What happens in an empty directory

---

### Step 2 — `terraform init`

* Why initialization exists
* What it downloads
* What it creates locally
* Why it must be run first

---

### Step 3 — Smallest Possible Terraform Configuration

* Write the minimum valid Terraform config
* Understand why it is valid
* No real resources yet

---

### Step 4 — `terraform plan`

* What Terraform reads during plan
* Why plan is safe
* What a “no changes” plan means

---

### Step 5 — `terraform apply`

* What apply does and does not do
* How apply updates state
* Why apply is not scary

---

### Step 6 — `terraform destroy`

* Destroy as reconciliation to zero
* What destroy reads
* Why destroy is safe with correct state

---

## 🚫 Hard Boundaries for Day 2

* No AWS provider
* No cloud credentials
* No copying full configs from tutorials
* No skipping prediction before commands

Every command must be **predicted before execution**.

---

## ✅ End Condition to Move Forward

Day 2 is complete only if I can:

* Explain what happens during `terraform init`
* Predict the output of `terraform plan`
* Explain exactly what `apply` changes locally
* Explain how and when state is created
* Run `destroy` without fear

Only after this do we move to **Day 3 (First real AWS resource)**.
