# Day 4 — Step 06: State Recovery via Import (Hands-On)

**Date:** February 9, 2026

**Phase:** DevOps Lock-In — Phase 2 (Terraform)

**Theme:** Restoring ownership without touching infrastructure

**Environment:** Existing AWS S3 bucket, missing local state

---

## 🎯 Objective

Recover Terraform ownership **safely** after state loss by using `terraform import`.

By the end of this step, you must be able to:

* Explain what import does and does NOT do
* Reattach an existing resource to Terraform state
* Verify recovery using `terraform plan`

No guessing. No recreation. No destruction.

---

## 🧠 What `terraform import` Really Is

`terraform import` is **not** a creator and **not** a fixer.

It does exactly one thing:

> Maps an existing real-world resource to a resource address in Terraform state.

It:

* Writes ownership into state
* Reads attributes from the provider
* Does NOT change cloud infrastructure
* Does NOT modify `.tf` configuration

Think of it as **memory restoration**.

---

## 🧱 Preconditions (Must Be True)

* The resource already exists in AWS
* Terraform configuration declares the resource
* State file is missing or incomplete
* You know the real-world resource identifier

If any of these are false → stop.

---

## 🔎 Identify What We’re Importing

From your configuration:

* Resource address: `aws_s3_bucket.demo_bucket`

From AWS reality:

* Resource ID (S3 bucket name): `devops-lock-in-demo-bucket`

These two must be paired.

---

## 🔮 Prediction (Say This Before Running)

Before importing:

* Terraform believes it owns nothing
* Plan shows `+ create`

After importing:

* Terraform believes it owns the bucket
* State contains bucket attributes
* `terraform plan` shows **No changes**

No AWS API mutations should occur.

---

## ▶️ Action: Import the Resource

Run **exactly**:

```
terraform import aws_s3_bucket.demo_bucket devops-lock-in-demo-bucket
```

This command:

* Calls AWS **read** APIs
* Writes state locally
* Does NOT create or delete anything

---

## 👀 What You Should Observe

* Terraform reports successful import
* `terraform.tfstate` is recreated
* Resource appears under `resources` in state

At this point:

* Ownership is restored
* Memory is back

---

## 🧪 Verification (Critical)

Immediately run:

```
terraform plan
```

Expected result:

* **No changes**
* Terraform and reality agree

If plan shows changes → stop and reason.

---

## 🧠 Core Mental Model (Lock This In)

```
Import = ownership assignment
Apply  = reality mutation
```

Never confuse the two.

---

## 🚫 Absolute Warnings

* Import does NOT generate configuration
* Import does NOT reconcile drift
* Import does NOT fix bad config

If config doesn’t match reality, import will still succeed — and plan will reveal mismatches.

---

## ✅ End Condition for Step 06

This step is complete only if:

* State is restored
* Plan shows no changes
* You understand why apply was dangerous earlier
* You trust import as the correct recovery tool

Next:
👉 **Day 4 — Final Reflection & Rules to Never Break**
