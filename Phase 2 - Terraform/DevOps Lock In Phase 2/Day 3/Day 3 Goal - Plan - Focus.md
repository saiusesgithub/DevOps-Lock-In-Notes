# 📅 Day 3 — First Real Infrastructure with Terraform (S3)

**Date:** February 8, 2026 (supposed to be doing on 10th feb but free on 8th feb because sunday)
**Phase:** DevOps Lock-In — Phase 2 (Terraform)  
**Theme:** First real cloud resource + provider + real state  
**Environment:** Local machine + AWS account (minimal, controlled)

---

## 🎯 Primary Goal for Day 3

Use Terraform to create **one real cloud resource** and fully understand:

- How Terraform talks to the real world
- How providers act as the bridge
- How state changes when real infrastructure exists

By the end of Day 3, creating and destroying real infrastructure should feel:
- Predictable
- Boring
- Reversible

If creating real infra feels scary → Day 3 is a failure.

---

## 🧠 Focus for the Day

Day 3 focuses on **introducing reality**, but in the smallest possible way.

Key focus areas:

- What a **provider** really is
- How Terraform authenticates to AWS
- How provider schemas enable resources
- How state changes when a real resource exists
- How `plan`, `apply`, and `destroy` behave with real infra

Still **no complexity**:
- One provider
- One resource
- One lifecycle

---

## 🧱 Why S3 Is Chosen

S3 is used intentionally because:

- No networking complexity
- No compute lifecycle
- Cheap and safe
- Easy to destroy and recreate
- Cleanly demonstrates Terraform concepts

This is **not** about learning S3.
This is about learning Terraform with real infra.

---

## 🧱 Execution Plan for Day 3

### Step 01 — Introduce the Provider Concept
- Understand what a provider is
- Why Terraform core cannot talk to AWS directly
- How providers plug into Terraform

(No code yet)

---

### Step 02 — Add AWS Provider Configuration
- Add provider block
- Understand region and authentication
- Observe how `terraform init` changes now

---

### Step 03 — First Real Resource (S3 Bucket)
- Add a single `aws_s3_bucket` resource
- Predict what plan will show
- Apply and create the bucket

---

### Step 04 — Inspect State with Real Resources
- Open `terraform.tfstate`
- Understand how Terraform tracks real infra
- Observe resource IDs and attributes

---

### Step 05 — Destroy and Rebuild
- Run `terraform destroy`
- Confirm bucket deletion
- Re-apply and recreate
- Observe state changes

Destroying infra is **mandatory**, not optional.

---

## 🚫 Hard Boundaries for Day 3

- Only **one** AWS resource
- No IAM complexity
- No modules
- No variables yet
- No copy-paste from tutorials

Every change must be:
- Predicted
- Observed
- Explained

---

## ✅ End Condition for Day 3

Day 3 is complete only if I can:

- Explain what a provider does
- Explain how Terraform talks to AWS
- Predict S3 creation before apply
- Explain how state tracks real resources
- Destroy and recreate infra without fear

Only after this do we move to:
**Day 4 — Terraform State Deep Dive (with real infra)**

