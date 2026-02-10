# Day 5 — Step 08: Hands-On Variable, Locals & Outputs Practice (Break & Rebuild)

**Date:** February 10, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** Practice > theory

**Environment:** AWS provider + S3 (reuse previous setup)

---

## 🎯 Objective of This Step

Convert **variables, tfvars, locals, and outputs** from concepts into
**muscle memory**.

By the end of this step, I must be able to:

* Refactor hardcoded values → variables
* Switch environments without touching core logic
* Use locals correctly (no hidden logic)
* Use outputs to expose useful results
* Predict `plan` output before running it

---

## 🧱 Practice Setup (Baseline)

You already have:

* AWS provider configured
* S3 bucket resource used earlier

We will **modify**, **break**, and **rebuild** this setup.

---

## 🔹 Exercise 1 — Kill All Hardcoding

### Task

Take your existing S3 resource and remove **every hardcoded value**:

* bucket name
* environment string
* tags

### Required

Create:

* `variables.tf`
* `terraform.tfvars`

Example targets (do **NOT** copy blindly, think first):

* `environment`
* `bucket_suffix`
* `common_tags`

---

### 🔮 Predict Before Running

Answer mentally **before** running plan:

* What will change in `terraform plan`?
* Will the bucket be replaced or updated in-place?
* Why?

Then run:

```bash
terraform plan
```

---

## 🔹 Exercise 2 — Environment Switch Without Code Changes

### Task

Create two tfvars files:

* `dev.tfvars`
* `prod.tfvars`

Only values should differ — **NO logic changes**.

Example differences:

* bucket naming
* tags
* environment name

Run:

```bash
terraform plan -var-file=dev.tfvars
terraform plan -var-file=prod.tfvars
```

---

### 🔮 Predict Before Running

* Will Terraform want to recreate the bucket?
* Why does it behave that way?
* What does this teach about environment isolation?

---

## 🔹 Exercise 3 — Introduce Locals (Safely)

### Task

Add a `locals` block to:

* Compute bucket name
* Centralize common tags

Rules:

* No conditionals
* No environment logic
* Only string interpolation / maps

Use locals inside the resource.

---

### 🔮 Predict Before Running

* Will plan show changes?
* Why or why not?

Then run:

```bash
terraform plan
```

---

## 🔹 Exercise 4 — Outputs as State Views

### Task

Add outputs for:

* bucket name
* bucket ARN
* region

Example pattern:

```hcl
output "bucket_arn" {
  value = aws_s3_bucket.example.arn
}
```

Run:

```bash
terraform apply
terraform output
```

---

### 🔮 Predict Before Running

* Will outputs affect infrastructure?
* When are output values resolved?
* Why can outputs not exist before apply?

---

## 🔹 Exercise 5 — Intentional Mistakes (VERY IMPORTANT)

Now we break things on purpose.

### A. Wrong Variable Type

* Declare a variable as `number`
* Pass a string via tfvars
* Observe the error

---

### B. Missing Required Variable

* Remove a variable value
* Run `terraform plan`
* Observe failure point

---

### C. Local Referencing Missing Variable

* Break a local
* See how Terraform fails early

---

## 🔥 Exercise 6 — Rebuild-From-Memory Test

Final test (no notes):

* New empty directory
* AWS provider
* Variables
* tfvars (dev)
* locals
* S3 bucket
* outputs

Run:

```bash
init → plan → apply → destroy
```

If you get stuck → that’s the learning signal.

---

## ✅ End Condition for Step 08

This step is complete only if I can:

* Switch environments using only tfvars
* Explain why no logic lives in tfvars
* Use locals without hiding intent
* Use outputs without abusing them
* Predict every plan before running it

---

## 🧭 Day 5 Completion Criteria

Day 5 is complete only if:

* No hardcoded infra values remain
* Variables, locals, outputs are clearly separated
* At least one failure was debugged manually
* Rebuild-from-memory was attempted
